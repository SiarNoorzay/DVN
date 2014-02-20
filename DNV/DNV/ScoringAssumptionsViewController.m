//
//  ScoringAssumptionsViewController.m
//  DNV
//
//  Created by USI on 1/24/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ScoringAssumptionsViewController.h"
#import "ReportDocViewController.h"
#import "ElementSubelementProfilesViewController.h"
#import "ListOfCompletedViewController.h"

@interface ScoringAssumptionsViewController ()

@end

@implementation ScoringAssumptionsViewController

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
    
    if (![self.audit.report.scoringAssumptions isEqualToString:@"(null)"])
    {
        self.scoreAssumpTextView.text = self.audit.report.scoringAssumptions;
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToProfiles"]) {
        
        ElementSubelementProfilesViewController * eleProfVC = [segue destinationViewController];
        
        eleProfVC.audit = self.audit;
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        
        int pixelsToMove = self.scoreAssumpTextView.frame.size.height;
        
        CGRect rect         = self.scoreAssumpTextView.frame;
        rect.size.height    = self.scoreAssumpTextView.contentSize.height;
        self.scoreAssumpTextView.frame  = rect;
        
        pixelsToMove = self.scoreAssumpTextView.frame.size.height - pixelsToMove;
        
        //make the pdfview height bigger
        rect = self.scoringAsumPDFView.frame;
        rect.size.height += pixelsToMove;
        int numPages = ceil( rect.size.height / 792 );
        rect.size.height = numPages * 792;
        self.scoringAsumPDFView.frame = rect;
        
        [reportVC.viewArray setObject:self.scoringAsumPDFView atIndexedSubscript:8];
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back to Completed Audits List" style:UIBarButtonItemStylePlain target:self action:@selector(popBackToCompletedAudits)];
    
}

-(void)popBackToCompletedAudits{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ListOfCompletedViewController class]]) {
            //Do not forget to import AnOldViewController.h
            
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.audit.report.scoringAssumptions = self.scoreAssumpTextView.text;
    
    //TODO: save audit back to DB
}

@end
