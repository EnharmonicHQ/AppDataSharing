//
//  ENHAppDataSharingController.h
//  AppDataSharing
//
//  Created by Dillan Laughlin on 2/6/13.
//  Copyright (c) 2013 Enharmonic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ENHAppDataPackage;

typedef void(^ENHAppDataSharingSendDataHandler)(BOOL *sent, NSError *error);
typedef void(^ENHAppDataSharingHandler)(ENHAppDataPackage *retrievedPackage, NSError *error);

extern NSString *kReadPasteboardDataQuery;

typedef enum
{
    ENHAppDataSharingErrorTypeNoApplicationAvailableForScheme = 100,
    ENHAppDataSharingErrorTypeNoPasteboardForName = 200,
    ENHAppDataSharingErrorTypeNoDataFound = 300,
} ENHAppDataSharingErrorType;

@interface ENHAppDataSharingController : NSObject

+(void)sendDataToApplicationWithScheme:(NSString *)scheme
                           dataPackage:(ENHAppDataPackage *)dataPackage
                     completionHandler:(ENHAppDataSharingSendDataHandler)completionHandler;

+(void)handleSendPasteboardDataURL:(NSURL *)sendPasteboardDataURL
                 completionHandler:(ENHAppDataSharingHandler)completionHandler;

@end
