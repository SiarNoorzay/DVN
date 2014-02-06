//
//  ReportDetailsViewController.m
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ReportDetailsViewController.h"
#import "ReportDocViewController.h"

@interface ReportDetailsViewController ()

@end

@implementation ReportDetailsViewController

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

    self.clientRef.text = self.audit.report.clientRef;
    self.summary.text = self.audit.report.summary;
    self.preparedBy.text = self.audit.report.preparedBy;
    self.approvedBy.text = self.audit.report.approvedBy;
    self.dateOfIssue.text = self.audit.client.auditDate;
    self.projectNum.text = [NSString stringWithFormat:@"%@",self.audit.report.projectNum];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.audit.report.clientRef = self.clientRef.text;
    self.audit.report.summary = self.summary.text;
    self.audit.report.preparedBy = self.preparedBy.text;
    self.audit.report.approvedBy = self.approvedBy.text;
    self.audit.client.auditDate = self.dateOfIssue.text;
    self.audit.report.projectNum = self.projectNum.text; 
    
    //TODO:save audit
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToExecutiveSummary"]) {
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        
        int pixelsToMove = self.summary.frame.size.height;

        CGRect rect         = self.summary.frame;
        rect.size.height    = self.summary.contentSize.height;
        self.summary.frame  = rect;
        
        pixelsToMove = self.summary.frame.size.height - pixelsToMove;
        
        //make the hieght view bigger
        rect = self.reportDetialsPDFView.frame;
        rect.size.height += pixelsToMove;
        self.reportDetialsPDFView.frame = rect;
        
        //move each uiElement under the summary down
        rect = self.preparedBy.frame;
        rect.origin.y += pixelsToMove;
        self.preparedBy.frame = rect;
        
        rect = self.preparedByLabel.frame;
        rect.origin.y += pixelsToMove;
        self.preparedByLabel.frame = rect;
        
        rect = self.approvedBy.frame;
        rect.origin.y += pixelsToMove;
        self.approvedBy.frame = rect;
        
        rect = self.approvedByLabel.frame;
        rect.origin.y += pixelsToMove;
        self.approvedByLabel.frame = rect;
        
        rect = self.dateOfIssueLabel.frame;
        rect.origin.y += pixelsToMove;
        self.dateOfIssueLabel.frame = rect;
        
        rect = self.dateOfIssue.frame;
        rect.origin.y += pixelsToMove;
        self.dateOfIssue.frame = rect;
        
        rect = self.projectNum.frame;
        rect.origin.y += pixelsToMove;
        self.projectNum.frame = rect;
        
        rect = self.projectNumLabel.frame;
        rect.origin.y += pixelsToMove;
        self.projectNumLabel.frame = rect;
        
        rect = self.copyrightLabel.frame;
        rect.origin.y += pixelsToMove;
        self.copyrightLabel.frame = rect;
        
        //set the frame to under the pdfview
        
        
        [reportVC.finalPFDView addSubview:self.reportDetialsPDFView];
        [reportVC.finalPFDView sizeToFit];
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
