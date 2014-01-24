//
//  ExecutiveSummaryViewController.m
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ExecutiveSummaryViewController.h"

@interface ExecutiveSummaryViewController ()

@end

@implementation ExecutiveSummaryViewController

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
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleCompletedAudit" ofType:@"json"]];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
    
    NSLog(@"JSON contains:\n%@", [dictionary description]);
    
    NSDictionary *theAudit = [dictionary objectForKey:@"Audit"];
    
    self.audit = [[Audit alloc]initWithAudit:theAudit];
    if (self.audit.report.executiveSummary != nil) {
        self.executiveSummary.text = self.audit.report.executiveSummary;
    }
    self.auditCountLabel.text = [NSString stringWithFormat:@"The audit consisted of %i elements.",[self.audit.Elements count]];
    NSString *tempEleList = @"Elements: ";
    
    for (int i = 0; i < [self.audit.Elements count]-1; i++)
    {
        Elements *ele = [self.audit.Elements objectAtIndex:i];
        tempEleList = [tempEleList stringByAppendingString:[NSString stringWithFormat:@"%i (%@), ",i+1, ele.name]];
    }
    Elements *ele = [self.audit.Elements objectAtIndex:[self.audit.Elements count]-1];
    tempEleList = [tempEleList stringByAppendingString:[NSString stringWithFormat:@"%i (%@). ",[self.audit.Elements count], ele.name]];
    
    self.elementList.text = tempEleList;
    
    if (self.audit.report.executiveSummary != nil) {
        self.executiveSummary.text = self.audit.report.executiveSummary;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.audit.report.executiveSummary = self.executiveSummary.text;
    
    //TODO: save audit
}

@end
