//
//  LogInViewController.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "LogInViewController.h"
#import <DropboxSDK/DropboxSDK.h>

#import "Audit.h"
#import "Elements.h"
#import "SubElements.h"
#import "Questions.h"
#import "Answers.h"
#import "Flurry.h"


@interface LogInViewController ()<DBRestClientDelegate>

{
    NSString *currentUser;
}

@end

@implementation LogInViewController

//@synthesize arrayOfUsers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.dnvDBManager = [DNVDatabaseManagerClass getSharedInstance];
    
    if (![[DBSession sharedSession] isLinked]) {
        [self.btnSetDropBox setTitle:@"Link to Dropbox"];
        [[DBSession sharedSession] linkFromController:self];
    }
    else
    {
        [self pingUserJsonSetUpTables];
        
        [restClient loadAccountInfo];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.userIDTextField.text = @"";
    self.passwordTextField.text = @"";
    
}

-(void)pingUserJsonSetUpTables
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"usersFromDB.json"];
    _directoryPath = filePath;
    
    //throw activity indicator setting
    [self activityOngoing:true];
    [self.restClient loadFile:@"/users.json" intoPath:filePath];
    
    
    //do we needed to delete usertable and then create?
    [self.dnvDBManager createUserTable];
    [self.dnvDBManager createAuditTables];
}

-(void)activityOngoing: (BOOL)doingActivity
{
    if( !doingActivity)
    {
        [self.actLinkingDropbox stopAnimating];
    }
    else
    {
        [self.actLinkingDropbox startAnimating];
    }
    
    [self.userIDTextField setEnabled:!doingActivity];
    [self.passwordTextField setEnabled:!doingActivity];
    [self.btnSetDropBox setEnabled:!doingActivity];
    [self.btnLogIn setEnabled:!doingActivity ];
}


- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath
       contentType:(NSString*)contentType metadata:(DBMetadata*)metadata {
    
    NSLog(@"File loaded into path: %@", localPath);
    [self getUserArray];
    
    [self activityOngoing:false];
    
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    NSLog(@"There was an error loading the file - %@", error);
    
#warning should we throw an alert here letting them know that we will use previously stored user json file if any?
    
    //get old array of users
    [self getUserArray];
    
    [self activityOngoing:false];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getUserArray{
    if (_directoryPath) { // check if file exists - if so load it:
        NSError *error;
        
        NSString *stringData = [NSString stringWithContentsOfFile:_directoryPath encoding:NSUTF8StringEncoding error:&error];
        NSData *data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
        NSLog(@"JSON contains:\n%@", [dictionary description]);

        self.arrayOfUsers = [[NSArray alloc ] initWithArray:[dictionary objectForKey:@"Users"]];
    }
}

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordTextField) {
        [textField resignFirstResponder];
        [self attemptToLogin];
        
    } else if (textField == self.userIDTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    return YES;
}

- (IBAction)LogInButton:(UIBarButtonItem *)sender {
    [self attemptToLogin];
}
-(void)attemptToLogin
{
    if( ![[DBSession sharedSession] isLinked] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"No dropbox linked!" message: @"Must be linked to a dropbox in order to login" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"No dropbox linked.");
    }
    else if( self.arrayOfUsers == nil || [self.arrayOfUsers count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"No Users!" message: @"Users json file is not present or contains zero users. Ensure you are linked to an appropriate dropbox." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Nil or empty userJson (arrayOfUsers)");
    }
    else
    {
        NSDictionary *loginParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         self.userIDTextField.text, @"userID", // Capture author info
         nil];
        
        BOOL foundUser = false;
        
        for (User *usr in self.arrayOfUsers) {
            
            [self.dnvDBManager saveUser:usr];
            
            if ([[usr objectForKey:@"userID" ] isEqualToString:self.userIDTextField.text]) {
                
                self.user = usr;
                foundUser = true;
                // break;
            }
        }
        
        if (foundUser) {
            BOOL passwordCorrect = false;
            
            if ([[self.user objectForKey:@"password" ] isEqualToString:self.passwordTextField.text]) {
                passwordCorrect= true;
                
                
                [Flurry logEvent:@"Successful Login" withParameters:loginParams];
                [Flurry setUserID:self.userIDTextField.text];
                
                
                NSLog(@"User name and password correct");
                [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
                
                //store current user in NSUSERDEFAULTS
                NSUserDefaults *nsDefaults = [NSUserDefaults standardUserDefaults];
                [nsDefaults setObject:self.userIDTextField.text forKey:@"currentUser"];
                [nsDefaults setObject:[self.user objectForKey:@"fullName"] forKey:@"currentUserName"];
                [nsDefaults synchronize];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Incorrect Password" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                NSLog(@"Incorrect password");
                
                [Flurry logEvent:@"Unsuccesful Login" withParameters:loginParams];
                
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"User ID not recognized" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"User ID not recognized");
            
            [Flurry logEvent:@"Unsuccesful Login" withParameters:loginParams];
            
        }
    }
}

- (IBAction)btnSetDropBox:(id)sender
{
    if( [[DBSession sharedSession] isLinked])
    {
        // unlink
        [[DBSession sharedSession] unlinkAll];
        
        self.arrayOfUsers = nil;
        
        [self.btnSetDropBox setTitle:@"Link to Dropbox"];
        
        UIAlertView *notLinked = [[UIAlertView alloc] initWithTitle:@"Unlinked!" message:[NSString stringWithFormat:@"You are now no longer linked to dropbox: %@", currentUser] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [notLinked show];
    }
    else
    {
        [[DBSession sharedSession] linkFromController:self];
    }
}

- (void)restClient:(DBRestClient*)client loadedAccountInfo:(DBAccountInfo*)info {
    currentUser = [info displayName];
    [self.btnSetDropBox setTitle:[NSString stringWithFormat:@"Dropbox linked: %@", currentUser]];
    
    if( self.showAlert)
    {
        UIAlertView *Linked = [[UIAlertView alloc] initWithTitle:@"Linked!" message:[NSString stringWithFormat:@"You are now linked to dropbox: %@", currentUser] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [Linked show];
        self.showAlert = false;
    }
}


@end
