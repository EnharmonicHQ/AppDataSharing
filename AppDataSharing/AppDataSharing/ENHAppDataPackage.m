//
//  ENHAppDataPackage.m
//  AppDataSharing
//
//  Created by Dillan Laughlin on 2/6/13.
//  Copyright (c) 2013 Enharmonic. All rights reserved.
//

#import "ENHAppDataPackage.h"

NSString *kENHAppDataPackageUTI = @"com.EnharmonicHQ.AppDataSharing.DataPackage";
static NSString *kENHPackageDataKey = @"kENHPackageDataKey";
static NSString *kENHSourceApplicationNameKey = @"kENHSourceApplicationNameKey";
static NSString *kENHSourceApplicationIdentifierKey = @"kENHSourceApplicationIdentifierKey";
static NSString *kENHSourceApplicationVersionKey = @"kENHSourceApplicationVersionKey";
static NSString *kENHSourceApplicationBuildKey = @"kENHSourceApplicationBuildKey";
static NSString *kENHPayloadKey = @"kENHPayloadKey";

@interface ENHAppDataPackage ()

// Metadata
@property (copy, nonatomic, readwrite) NSString *sourceApplicationName;
@property (copy, nonatomic, readwrite) NSString *sourceApplicationIdentifier;
@property (copy, nonatomic, readwrite) NSString *sourceApplicationVersion;
@property (copy, nonatomic, readwrite) NSString *sourceApplicationBuild;

// Application Data
@property (strong, nonatomic, readwrite) NSData *payload;

@end

@implementation ENHAppDataPackage

-(id)initWithSourceApplicationName:(NSString *)sourceApplicationName
       sourceApplicationIdentifier:(NSString *)sourceApplicationIdentifier
          sourceApplicationVersion:(NSString *)sourceApplicationVersion
            sourceApplicationBuild:(NSString *)sourceApplicationBuild
                           payload:(NSData *)payload
{
    self = [super init];
    if (self)
    {
        [self setSourceApplicationName:sourceApplicationName];
        [self setSourceApplicationIdentifier:sourceApplicationIdentifier];
        [self setSourceApplicationVersion:sourceApplicationVersion];
        [self setSourceApplicationBuild:sourceApplicationBuild];
        [self setPayload:payload];
    }
    
    return self;
}

+(ENHAppDataPackage *)dataPackageForCurrentApplicationWithPayload:(NSData *)payload
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *currentApplicationName = [infoPlist valueForKey:@"CFBundleDisplayName"];
    NSString *currentApplicationIdentifier = [infoPlist valueForKey:@"CFBundleIdentifier"];
    NSString *currentApplicationVersion = [infoPlist valueForKey:@"CFBundleShortVersionString"];
    NSString *currentApplicationBuild = [infoPlist valueForKey:@"CFBundleVersion"];
    
    ENHAppDataPackage *package = [[[self class] alloc] initWithSourceApplicationName:currentApplicationName
                                                         sourceApplicationIdentifier:currentApplicationIdentifier
                                                            sourceApplicationVersion:currentApplicationVersion
                                                              sourceApplicationBuild:currentApplicationBuild
                                                                             payload:payload];
    
    return package;
}

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.sourceApplicationName forKey:kENHSourceApplicationNameKey];
    [encoder encodeObject:self.sourceApplicationIdentifier forKey:kENHSourceApplicationIdentifierKey];
    [encoder encodeObject:self.sourceApplicationVersion forKey:kENHSourceApplicationVersionKey];
    [encoder encodeObject:self.sourceApplicationBuild forKey:kENHSourceApplicationBuildKey];
    [encoder encodeObject:self.payload forKey:kENHPayloadKey];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    NSString *sourceApplicationName = [decoder decodeObjectForKey:kENHSourceApplicationNameKey];
    NSString *sourceApplicationIdentifier = [decoder decodeObjectForKey:kENHSourceApplicationIdentifierKey];
    NSString *sourceApplicationVersion = [decoder decodeObjectForKey:kENHSourceApplicationVersionKey];
    NSString *sourceApplicationBuild = [decoder decodeObjectForKey:kENHSourceApplicationBuildKey];
    NSData *payload = [decoder decodeObjectForKey:kENHPayloadKey];
    
    return [self initWithSourceApplicationName:sourceApplicationName
                   sourceApplicationIdentifier:sourceApplicationIdentifier
                      sourceApplicationVersion:sourceApplicationVersion
                        sourceApplicationBuild:sourceApplicationBuild
                                       payload:payload];
}


#pragma mark - Data Helpers

-(NSData *)dataRepresentation
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:kENHPackageDataKey];
    [archiver finishEncoding];
    
    return [NSData dataWithData:data];
}

+(ENHAppDataPackage *)unarchivePackageData:(NSData *)data
{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    ENHAppDataPackage *package = [unarchiver decodeObjectForKey:kENHPackageDataKey];
    [unarchiver finishDecoding];
    
    return package;
}

#pragma mark - Accessors

@synthesize sourceApplicationName = _sourceApplicationName;
@synthesize sourceApplicationIdentifier = _sourceApplicationIdentifier;
@synthesize sourceApplicationVersion = _sourceApplicationVersion;
@synthesize sourceApplicationBuild = _sourceApplicationBuild;
@synthesize payload = _payload;

@end
