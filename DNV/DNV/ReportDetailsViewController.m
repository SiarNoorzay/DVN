//
//  ReportDetailsViewController.m
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ReportDetailsViewController.h"

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
