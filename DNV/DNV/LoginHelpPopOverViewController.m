//
//  LoginHelpPopOverViewController.m
//  DNV
//
//  Created by USI on 1/15/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "LoginHelpPopOverViewController.h"

@interface LoginHelpPopOverViewController ()


@end
NSString *emailString = @"support@dvn-gl.com";

@implementation LoginHelpPopOverViewController

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
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)supportEmailButtonPushed:(id)sender {
    if ([MFMailComposeViewController canSendMail])

    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        // Set the subject of email
        [picker setSubject:@"Login Support Inquiry"];
        
        // Add email addresses
        // Notice three sections: "to" "cc" and "bcc"
        [picker setToRecipients:[NSArray arrayWithObjects:emailString, nil]];
        
        //    [picker setCcRecipients:[NSArray arrayWithObject:@"CC MailID"]];
        //    [picker setBccRecipients:[NSArray arrayWithObject:@"BCC Mail ID"]];
        
        // Fill out the email body text
        
        // This is not an HTML formatted email
        
        // Show email view
//        [self presentModalViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:Nil];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Email is not setup on this device" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
}

- (void) mailComposeController: (MFMailComposeViewController *) controller
           didFinishWithResult: (MFMailComposeResult) result
                         error: (NSError *) error {
    
    if(result == MFMailComposeResultSent){
        [self dismissViewControllerAnimated:YES completion:NULL];

    } else if (result == MFMailComposeResultCancelled) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
