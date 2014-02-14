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

-(void)viewWillAppear:(BOOL)animated
{
    int needsV = self.theAnswersVC.question.needsVerifying;
    
    if( needsV % 2 != 0   )
        [self btnToggler:self.btnPhysical];
    
    if( needsV %4 > 1 )
        [self btnToggler:self.btnInterviews];
    
    if( needsV >= 4 )
        [self btnToggler:self.btnRecords];
    
    if (needsV == 0)
        [[self btnGoToVerifyTabBar] setEnabled:false];
    else
        [[self btnGoToVerifyTabBar] setEnabled:true];
    
    //should i set needv back to needsVerifying, shouldn't have to
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
    //shows V toggled on if needs verifying enum is greater than zerp
    [self.theAnswersVC setNeedsVerifying:self.theAnswersVC.question.needsVerifying];
    
    if( self.btnPhysical.tag == 0)
    {
        [self.theAnswersVC.dnvDBManager deleteVerifyForQuestion:self.theAnswersVC.question.questionID ofType:0];
        
        self.theAnswersVC.question.PhysicalObservations = nil;
    }
    
    if( self.btnInterviews.tag == 0)
    {
        [self.theAnswersVC.dnvDBManager deleteVerifyForQuestion:self.theAnswersVC.question.questionID ofType:1];
        
        self.theAnswersVC.question.InterviewObservations = nil;
    }
    
    if( self.btnRecords.tag == 0)
    {
        [self.theAnswersVC.dnvDBManager deleteVerifyForQuestion:self.theAnswersVC.question.questionID ofType:2];
        
        self.theAnswersVC.question.Records = nil;
    }
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
    
    ////enum logic, 0-7 representing binary, 000-111
    //physical will represent 0 or 1
    //interview will represent 0 or 2
    //records will represent 0 or 4
    self.theAnswersVC.question.needsVerifying = self.btnPhysical.tag * 1 + self.btnInterviews.tag *2 + self.btnRecords.tag * 4;
   
    if( self.theAnswersVC.question.needsVerifying == 0)
        [[self btnGoToVerifyTabBar] setEnabled:false];
    else
        [[self btnGoToVerifyTabBar] setEnabled:true];
}

- (IBAction)btnGoToVerifyTabBar:(id)sender
{
    [self.theAnswersVC.verifyPopOver dismissPopoverAnimated:YES];
    [self.theAnswersVC performSegueWithIdentifier:@"questionToVerify" sender:self.theAnswersVC];
}

@end
