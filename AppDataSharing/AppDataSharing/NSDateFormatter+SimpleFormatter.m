//
//  NSDateFormatter+SimpleFormatter.m
//  AppDataSharing
//
//  Created by Dillan Laughlin on 2/5/13.
//  Copyright (c) 2013 Enharmonic. All rights reserved.
//

#import "NSDateFormatter+SimpleFormatter.h"

@implementation NSDateFormatter (SimpleFormatter)

+(NSDateFormatter *)simpleFormatter;
{
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setLocale:[NSLocale currentLocale]];
    }
    return dateFormatter;
}

@end
