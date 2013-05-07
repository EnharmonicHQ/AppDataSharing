//
//  ENHPerson.m
//  AppDataSharing
//
//  Created by Dillan Laughlin on 2/5/13.
//  Copyright (c) 2013 Enharmonic. All rights reserved.
//

#import "ENHPerson.h"

static NSString *kENHPersonKey = @"kENHPersonKey";
static NSString *kENHPersonFirstNameKey = @"kENHPersonFirstNameKey";
static NSString *kENHPersonLastNameKey = @"kENHPersonLastNameKey";
static NSString *kENHPersonDateOfBirthKey = @"kENHPersonDateOfBirthKey";

@implementation ENHPerson

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
        [self setFirstName:[decoder decodeObjectForKey:kENHPersonFirstNameKey]];
        [self setLastName:[decoder decodeObjectForKey:kENHPersonLastNameKey]];
        [self setDateOfBirth:[decoder decodeObjectForKey:kENHPersonDateOfBirthKey]];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.firstName forKey:kENHPersonFirstNameKey];
    [encoder encodeObject:self.lastName forKey:kENHPersonLastNameKey];
    [encoder encodeObject:self.dateOfBirth forKey:kENHPersonDateOfBirthKey];
}

-(NSData *)dataRepresentation
{
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:kENHPersonKey];
    [archiver finishEncoding];
    
    return [NSData dataWithData:data];
}

+(ENHPerson *)personWithData:(NSData *)data
{
    NSParameterAssert(data);
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    ENHPerson *person = [unarchiver decodeObjectForKey:kENHPersonKey];
    [unarchiver finishDecoding];
    
    return person;
}

#pragma mark - Accessors
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize dateOfBirth = _dateOfBirth;

@end
