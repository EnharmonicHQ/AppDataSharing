//
//  ENHAppDataSharingController.m
//  AppDataSharing
//
//  Created by Dillan Laughlin on 2/6/13.
//  Copyright (c) 2013 Enharmonic. All rights reserved.
//

#import "ENHAppDataSharingController.h"
#import "ENHAppDataPackage.h"

NSString *kReadPasteboardDataQuery = @"ReadPasteboardData";
NSString *const AppDataSharingErrorDomain = @"AppDataSharingErrorDomain";

@implementation ENHAppDataSharingController

+(void)sendDataToApplicationWithScheme:(NSString *)scheme
                           dataPackage:(ENHAppDataPackage *)dataPackage
                     completionHandler:(ENHAppDataSharingSendDataHandler)completionHandler;
{
    NSError *error = nil;
    
    // Setup the Pasteboard
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithUniqueName];
    [pasteboard setPersistent:YES]; // Makes sure the pasteboard lives beyond app termination.
    NSString *pasteboardName = [pasteboard name];
    
    // Write The Data
    NSData *data = [dataPackage dataRepresentation];
    NSString *pasteboardType = kENHAppDataPackageUTI;
    [pasteboard setData:data forPasteboardType:pasteboardType];
    
    // Launch the destination app
    NSURL *sendingURL = [[self class] sendPasteboardDataURLForScheme:scheme pasteboardName:pasteboardName];
    if ([[UIApplication sharedApplication] canOpenURL:sendingURL])
    {
        completionHandler(YES, nil);
        [[UIApplication sharedApplication] openURL:sendingURL];
    }
    else
    {
        [pasteboard setData:nil forPasteboardType:pasteboardType];
        [pasteboard setPersistent:NO];
        
        NSDictionary *errorInfoDictionary = @{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"No application was found to handle the url:", nil), sendingURL]};
        error = [NSError errorWithDomain:AppDataSharingErrorDomain
                                    code:ENHAppDataSharingErrorTypeNoApplicationAvailableForScheme
                                userInfo:errorInfoDictionary];
    }
    
    completionHandler(NO, error);
}

+(void)handleSendPasteboardDataURL:(NSURL *)sendPasteboardDataURL
                 completionHandler:(ENHAppDataSharingHandler)completionHandler;
{
    NSString *query = [sendPasteboardDataURL query];
    NSString *pasteboardName = [sendPasteboardDataURL fragment];
    NSAssert2(([query isEqualToString:kReadPasteboardDataQuery] && pasteboardName), @"Malformed or incorrect url sent to %@. URL: %@", NSStringFromSelector(_cmd), sendPasteboardDataURL);
    
    ENHAppDataPackage *dataPackage = nil;
    NSError *error = nil;
    
    NSString *pasteboardType = kENHAppDataPackageUTI;
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:pasteboardName create:NO];
    if (pasteboard)
    {
        NSData *data = [pasteboard dataForPasteboardType:pasteboardType];
        if (data)
        {
            dataPackage = [ENHAppDataPackage unarchivePackageData:data];
        }
        else
        {
            NSDictionary *errorInfoDictionary = @{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"No data found on pasteboard with name:", nil), pasteboardName]};
            error = [NSError errorWithDomain:AppDataSharingErrorDomain
                                        code:ENHAppDataSharingErrorTypeNoDataFound
                                    userInfo:errorInfoDictionary];
        }
        [pasteboard setData:nil forPasteboardType:pasteboardType];
    }
    else
    {
        NSDictionary *errorInfoDictionary = @{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"No pasteboard found for name:", nil), pasteboardName]};
        error = [NSError errorWithDomain:AppDataSharingErrorDomain
                                    code:ENHAppDataSharingErrorTypeNoPasteboardForName
                                userInfo:errorInfoDictionary];
    }
    completionHandler(dataPackage, error);
}

#pragma mark - URLs

+(NSURL *)sendPasteboardDataURLForScheme:(NSString *)scheme pasteboardName:(NSString *)pasteboardName
{
    NSString *urlString = [NSString stringWithFormat:@"%@://?%@#%@", scheme, kReadPasteboardDataQuery, pasteboardName];
    
    return [NSURL URLWithString:urlString];
}

@end
