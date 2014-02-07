//
//  ScoringAssumptionsViewController.m
//  DNV
//
//  Created by USI on 1/24/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ScoringAssumptionsViewController.h"
#import "ReportDocViewController.h"

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
    
    //TODO: get audit from DB instead of bundle
    // self.audit = getAuditFromDB with ID from previous selection
    
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleCompletedAudit" ofType:@"json"]];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
    
    NSLog(@"JSON contains:\n%@", [dictionary description]);
    
    NSDictionary *theAudit = [dictionary objectForKey:@"Audit"];
    
    self.audit = [[Audit alloc]initWithAudit:theAudit];
    
    if (self.audit.report.scoringAssumptions != nil)
    {
        self.scoreAssumpTextView.text = self.audit.report.scoringAssumptions;
        
    }
    

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToProfiles"]) {
        
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
        
        //set the frame of this view to the bottom of the finalPdfview
//        rect = self.scoringAsumPDFView.frame;
//        rect.origin.y = reportVC.finalPFDView.frame.size.height;
//        self.scoringAsumPDFView.frame = rect;
//        
//        
//        [reportVC.finalPFDView addSubview:self.scoringAsumPDFView];
//        [reportVC.finalPFDView sizeToFit];
        
       // [reportVC.viewArray addObject:self.scoringAsumPDFView];
        
        [reportVC.viewArray setObject:self.scoringAsumPDFView atIndexedSubscript:8];
        

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
