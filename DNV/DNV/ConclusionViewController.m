//
//  ConclusionViewController.m
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ConclusionViewController.h"

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
    //TODO: get audit from DB instead of bundle
    // self.audit = getAuditFromDB with ID from previous selection
    
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleCompletedAudit" ofType:@"json"]];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
    
    NSLog(@"JSON contains:\n%@", [dictionary description]);
    
    NSDictionary *theAudit = [dictionary objectForKey:@"Audit"];
    
    self.audit = [[Audit alloc]initWithAudit:theAudit];
    
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
    
    if (self.audit.report.conclusion != nil) {
        self.conclusionTextView.text = self.audit.report.conclusion;
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
