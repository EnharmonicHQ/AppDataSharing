//
//  ENHPersonDetailViewController.m
//  AppDataSharing
//
//  Created by Dillan Laughlin on 2/5/13.
//  Copyright (c) 2013 Enharmonic. All rights reserved.
//

#import "ENHPersonDetailViewController.h"
#import "ENHPerson.h"
#import "NSDateFormatter+SimpleFormatter.h"

#import "ENHPasteboardAppDataSharingController.h"
#import "ENHAppDataPackage.h"

@interface ENHPersonDetailViewController ()

@property (strong, nonatomic) ENHPerson *person;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirthLabel;

@end

@implementation ENHPersonDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitle:NSLocalizedString(@"Viewer", nil)];
    [self.nameLabel setText:@""];
    [self.dateOfBirthLabel setText:@""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleOpenURL:)
                                                 name:@"ENHHandleOpenURLNotification"
                                               object:nil];
}

-(void)handleOpenURL:(NSNotification *)notification
{
    NSURL *url = [notification object];
    if ([[url query] isEqualToString:kReadPasteboardDataQuery])
    {
        [ENHPasteboardAppDataSharingController handleSendPasteboardDataURL:url
                                               completionHandler:^(ENHAppDataPackage *retrievedPackage, NSError *error) {
            if (retrievedPackage)
            {
                NSData *packageData = [retrievedPackage payload];
                ENHPerson *person = [ENHPerson personWithData:packageData];
                [self setPerson:person];
            }
            else
            {
                NSLog(@"Error handling pasteboard data url: %@", [error localizedDescription]);
            }
        }];
    }
}

#pragma mark - Accessors

-(void)setPerson:(ENHPerson *)person
{
    if (_person != person)
    {
        _person = person;
        NSString *name = @"";
        if ([_person firstName])
        {
            name = [name stringByAppendingString:[_person firstName]];
        }
        if ([name length] > 0)
        {
            name = [name stringByAppendingString:@" "];
        }
        if ([_person lastName])
        {
            name = [name stringByAppendingString:[_person lastName]];
        }
        [self.nameLabel setText:name];
        
        if ([_person dateOfBirth])
        {
            NSString *dateString = [[NSDateFormatter simpleFormatter] stringFromDate:[_person dateOfBirth]];
            [self.dateOfBirthLabel setText:dateString];
        }
    }
}

@end
