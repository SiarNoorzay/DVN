//
//  LogInViewController.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNVDatabaseManagerClass.h"

#import "User.h"

#import "Reachability.h"

@class DBRestClient;

@interface LogInViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>{
    
    DBRestClient* restClient;
}

@property (nonatomic, readonly) DBRestClient * restClient;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actLinkingDropbox;


@property (assign) BOOL showAlert;

//Reachability properties
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

//User Info Textfields
@property (strong, nonatomic) IBOutlet UITextField *userIDTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

//File properties
@property NSString * myDirectory;
@property NSString * directoryPath;

//User properties
@property (strong, nonatomic) User * user;
@property (strong, nonatomic) NSArray * arrayOfUsers;

@property (strong, nonatomic) DNVDatabaseManagerClass * dnvDBManager;

//Log In Button
- (IBAction)LogInButton:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnLogIn;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSetDropBox;
- (IBAction)btnSetDropBox:(id)sender;

-(void)pingUserJsonSetUpTables;

@end
