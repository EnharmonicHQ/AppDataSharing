//
//  ENHAppDataPackage.h
//  AppDataSharing
//
//  Created by Dillan Laughlin on 2/6/13.
//  Copyright (c) 2013 Enharmonic. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kENHAppDataPackageUTI;

@interface ENHAppDataPackage : NSObject <NSCoding>

// Metadata
@property (copy, nonatomic, readonly) NSString *sourceApplicationName;
@property (copy, nonatomic, readonly) NSString *sourceApplicationIdentifier;
@property (copy, nonatomic, readonly) NSString *sourceApplicationVersion;
@property (copy, nonatomic, readonly) NSString *sourceApplicationBuild;

// Application Data
@property (strong, nonatomic, readonly) NSData *payload;

-(id)initWithSourceApplicationName:(NSString *)sourceApplicationName
       sourceApplicationIdentifier:(NSString *)sourceApplicationIdentifier
          sourceApplicationVersion:(NSString *)sourceApplicationVersion
            sourceApplicationBuild:(NSString *)sourceApplicationBuild
                           payload:(NSData *)payload;

+(ENHAppDataPackage *)dataPackageForCurrentApplicationWithPayload:(NSData *)payload;


-(NSData *)dataRepresentation;
+(ENHAppDataPackage *)unarchivePackageData:(NSData *)data;

@end
