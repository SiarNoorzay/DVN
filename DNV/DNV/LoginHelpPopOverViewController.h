//
//  LoginHelpPopOverViewController.h
//  DNV
//
//  Created by USI on 1/15/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "LogInViewController.h"

@interface LoginHelpPopOverViewController : UIViewController<MFMailComposeViewControllerDelegate>

- (IBAction)supportEmailButtonPushed:(id)sender;

@end
