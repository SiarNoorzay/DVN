//
//  ConclusionViewController.m
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ConclusionViewController.h"
#import "ReportDocViewController.h"
#import "KeySuggestionsViewController.h"
#import "ListOfCompletedViewController.h"

@interface ConclusionViewController ()

@end

@implementation ConclusionViewController

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
    
    float auditPointsPossible = 0;
    float auditNAPoints = 0;
    float auditAwarded = 0;
    
    for (int i = 0; i< [self.audit.Elements count]; i++) {
        Elements *ele = [self.audit.Elements objectAtIndex:i];
        
        auditPointsPossible += ele.pointsPossible;
        auditNAPoints += ele.modefiedNAPoints;
        auditAwarded += ele.pointsAwarded;
    }
    self.percent.text = [NSString stringWithFormat:@"%.2f %%",((auditAwarded / (auditPointsPossible - auditNAPoints)) *100)];
    
    if (!([self.audit.report.conclusion isEqualToString:@"(null)"] ||[self.audit.report.conclusion isEqualToString:@""])) {
        self.conclusionTextView.text = self.audit.report.conclusion;
    }
    else self.conclusionTextView.text = @"<insert text here>";
    
    
}

- (void)textViewDidBeginEditing:(UITextView*)textView
{
    NSString *notes =textView.text;
    notes = [notes stringByReplacingOccurrencesOfString:@"<insert text here>" withString:@""];
    textView.text = notes;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToKeySugs"]) {
        
        KeySuggestionsViewController * keySugsVC = [segue destinationViewController];
        
        keySugsVC.audit = self.audit;
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        
        int pixelsToMove = self.conclusionTextView.frame.size.height;
        
        CGRect rect         = self.conclusionTextView.frame;
        rect.size.height    = self.conclusionTextView.contentSize.height;
        self.conclusionTextView.frame  = rect;
        
        pixelsToMove = self.conclusionTextView.frame.size.height - pixelsToMove;
        
        //make the pdfview height bigger
        rect = self.conclusionPFDView.frame;
        rect.size.height += pixelsToMove;
        int numPages = ceil( rect.size.height / 792 );
        rect.size.height = numPages * 792;
        self.conclusionPFDView.frame = rect;

        [reportVC.viewArray setObject:self.conclusionPFDView atIndexedSubscript:5];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)viewWillDisappear:(BOOL)animated
{
    self.audit.report.conclusion = self.conclusionTextView.text;
    
    //TODO:save audit back to DB
}

@end
