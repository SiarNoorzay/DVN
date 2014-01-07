//
//  LogInViewController.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class DBRestClient;

@interface LogInViewController : UIViewController{
    
    DBRestClient* restClient;
}

//User Info Textfields
@property (strong, nonatomic) IBOutlet UITextField *userIDTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

//File properties
@property NSString * myDirectory;
@property NSString * directoryPath;

//User properties
@property (strong, nonatomic) User * user;
@property (strong, nonatomic) NSArray * arrayOfUsers;

//Log In Button
- (IBAction)LogInButton:(UIBarButtonItem *)sender;


@end
