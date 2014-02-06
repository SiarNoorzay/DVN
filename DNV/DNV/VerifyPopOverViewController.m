//
//  VerifyPopOverViewController.m
//  DNV
//
//  Created by Jaime Martinez on 2/4/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "VerifyPopOverViewController.h"

@interface VerifyPopOverViewController ()

@end

@implementation VerifyPopOverViewController

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

-(void)viewWillDisappear:(BOOL)animated
{
    //to change/work with enum we had discussed
    [self.theAnswersVC setNeedsVerifying: self.btnInterviews.tag + self.btnPhysical.tag + self.btnRecords.tag];
}

- (IBAction)btnToggler:(id)sender
{
    if( [sender tag] == 0 )
    {
        [sender setTag:1];
        [sender setAlpha:1.0];
    }
    else
    {
        [sender setTag:0];
        [sender setAlpha:0.3];
    }
}

- (IBAction)btnGoToVerifyTabBar:(id)sender
{
    [self.theAnswersVC.verifyPopOver dismissPopoverAnimated:YES];
    [self.theAnswersVC performSegueWithIdentifier:@"questionToVerify" sender:self.theAnswersVC];
}

@end
