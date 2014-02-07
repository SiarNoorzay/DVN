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
    
    
//    NSError *error;
//    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleCompletedAudit" ofType:@"json"]];
//    
//    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
//    
//    NSLog(@"JSON contains:\n%@", [dictionary description]);
//    
//    NSDictionary *theAudit = [dictionary objectForKey:@"Audit"];
//    
//    self.audit = [[Audit alloc]initWithAudit:theAudit];
    
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
    
    if (![self.audit.report.conclusion isEqualToString:@"(null)"]) {
        self.conclusionTextView.text = self.audit.report.conclusion;
    }
    
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
        
        //move each uiElement under the conclusion text view down
        rect = self.percent.frame;
        rect.origin.y += pixelsToMove;
        self.percent.frame = rect;
        
        rect = self.overPercentLabel.frame;
        rect.origin.y += pixelsToMove;
        self.overPercentLabel.frame = rect;
        
        
        //set the frame of this view to the bottom of the finalPdfview
//        rect = self.conclusionPFDView.frame;
//        rect.origin.y = reportVC.finalPFDView.frame.size.height;
//        self.conclusionPFDView.frame = rect;
//        
//        
//        [reportVC.finalPFDView addSubview:self.conclusionPFDView];
//        [reportVC.finalPFDView sizeToFit];
        
      //  [reportVC.viewArray addObject:self.conclusionPFDView];

        [reportVC.viewArray setObject:self.conclusionPFDView atIndexedSubscript:5];
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.audit.report.conclusion = self.conclusionTextView.text;
    
    //TODO:save audit back to DB
}

@end
