//
//  LogInViewController.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObject.h"

@interface LogInViewController : UIViewController

//User Info Textfields
@property (strong, nonatomic) IBOutlet UITextField *userIDTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) UserObject * user;

//Log In Button
- (IBAction)LogInButton:(UIBarButtonItem *)sender;


@end
