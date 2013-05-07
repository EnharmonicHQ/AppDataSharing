//
//  ENHViewController.m
//  AppDataSharing
//
//  Created by Dillan Laughlin on 2/5/13.
//  Copyright (c) 2013 Enharmonic. All rights reserved.
//

#import "ENHPersonEditorViewController.h"
#import "ENHPerson.h"

// Data Sharing
#import "ENHAppDataPackage.h"
#import "ENHAppDataSharingController.h"

static NSString *kViewerURLScheme = @"com.EnharmonicHQ.Viewer";

@interface ENHPersonEditorViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthDatePicker;

@property(strong, nonatomic) ENHPerson *person;

@end

@implementation ENHPersonEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setTitle:NSLocalizedString(@"Person Editor", nil)];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped:)];
    [self.navigationItem setLeftBarButtonItem:saveButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    NSData *personData = [NSData dataWithContentsOfURL:[[self class] personDataURL]];
    ENHPerson *person = nil;
    if (personData)
    {
        person = [ENHPerson personWithData:personData];
    }
    else
    {
        person = [[ENHPerson alloc] init];
    }
    [self setPerson:person];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *actionButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                      target:self
                                                                                      action:@selector(actionButtonItemTapped:)];
    NSString *urlString = [NSString stringWithFormat:@"%@://", kViewerURLScheme];
    NSURL *url = [NSURL URLWithString:urlString];
    [actionButtonItem setEnabled:[[UIApplication sharedApplication] canOpenURL:url]];
    [self.navigationItem setRightBarButtonItem:actionButtonItem];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self savePerson];
}

+(NSURL *)personDataURL
{
    NSArray *documentURLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = documentURLs[0];
    
    NSURL *personDataURL = [NSURL URLWithString:@"Person.ENHPerson" relativeToURL:documentsDirectory];
    
    return personDataURL;
}

-(void)savePerson
{
    NSData *personData = [self.person dataRepresentation];
    [personData writeToURL:[[self class] personDataURL] atomically:YES];
}

-(void)dismissKeyboard:(UIGestureRecognizer *)recognizer
{
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField resignFirstResponder];
}

#pragma mark - Actions

-(IBAction)actionButtonItemTapped:(id)sender
{
    NSData *personData = [self.person dataRepresentation];
    ENHAppDataPackage *package = [ENHAppDataPackage dataPackageForCurrentApplicationWithPayload:personData];
    [ENHAppDataSharingController sendDataToApplicationWithScheme:kViewerURLScheme
                                                     dataPackage:package
                                               completionHandler:^(BOOL *sent, NSError *error) {
        if (sent)
        {
            NSLog(@"Data Package Sent");
        }
        else if (error)
        {
            NSLog(@"Error sending data package: %@", [error localizedDescription]);
        }
    }];
}

-(IBAction)saveButtonTapped:(id)sender
{
    [self savePerson];
}

-(IBAction)datePickerValueChanged:(id)sender
{
    NSDate *date = [self.birthDatePicker date];
    [self.person setDateOfBirth:date];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == [self firstNameTextField])
    {
        [self.lastNameTextField becomeFirstResponder];
    }
    else if (textField == [self lastNameTextField])
    {
        [self.lastNameTextField resignFirstResponder];
    }
    
    return YES;
}

-(void)textDidChange:(NSNotification *)notification
{
    [self.person setFirstName:self.firstNameTextField.text];
    [self.person setLastName:self.lastNameTextField.text];
}

#pragma mark - Accessors

@synthesize person = _person;
-(void)setPerson:(ENHPerson *)person
{
    if (_person != person)
    {
        _person = person;
        [self.firstNameTextField setText:_person.firstName];
        [self.lastNameTextField setText:_person.lastName];
        if ([_person dateOfBirth])
        {
            [self.birthDatePicker setDate:_person.dateOfBirth animated:YES];
        }
    }
}

@end
