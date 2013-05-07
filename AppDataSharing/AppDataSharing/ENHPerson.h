//
//  ENHPerson.h
//  AppDataSharing
//
//  Created by Dillan Laughlin on 2/5/13.
//  Copyright (c) 2013 Enharmonic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ENHPerson : NSObject <NSCoding>

@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSDate *dateOfBirth;

-(NSData *)dataRepresentation;
+(ENHPerson *)personWithData:(NSData *)data;

@end
