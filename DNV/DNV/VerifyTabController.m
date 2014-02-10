//
//  VerifyTabController.m
//  DNV
//
//  Created by Jaime Martinez on 2/3/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "VerifyTabController.h"
#import "AnswersViewController.h"

@interface VerifyTabController ()

@end

@implementation VerifyTabController

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
    NSLog(@"%@", self.viewControllers);
    
    NSMutableArray *someVCs = [NSMutableArray new];
    
    int needsV = self.theQuestion.needsVerifying;
    
    if( needsV % 2 != 0   )
        [someVCs addObject:[self.viewControllers objectAtIndex:0]];
    
    if( needsV %4 > 1 )
        [someVCs addObject:[self.viewControllers objectAtIndex:1]];
    
    if( needsV >= 4 )
        [someVCs addObject:[self.viewControllers objectAtIndex:2]];
    
    [self setViewControllers:someVCs animated:YES];
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

- (IBAction)btnEditQuestion:(id)sender
{
    [self performSegueWithIdentifier:@"verifyTabToDashboard" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:@"verifyTabToDashboard"])
    {
        //to recursively go through and find all verified questions!!
        AnswersViewController *answersVC = [segue destinationViewController];
        
        answersVC.question = self.theQuestion;
        answersVC.questionArray = self.listOfVerifyQuestions;
        answersVC.currentPosition = self.currentSpot;
        
    }
}
@end
