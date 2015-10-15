//
//  ENHAppDelegate.m
//  AppDataSharing
//
//  Created by Dillan Laughlin on 2/5/13.
//  Copyright (c) 2013 Enharmonic. All rights reserved.
//

#import "ENHAppDelegate.h"

@implementation ENHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"Application launched with URL: %@", url);
    if ([sourceApplication hasPrefix:@"com.EnharmonicHQ"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ENHHandleOpenURLNotification" object:url];
        return YES;
    }
    
    return NO;
}

@end
