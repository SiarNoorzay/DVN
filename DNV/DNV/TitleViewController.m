//
//  TitleViewController.m
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "TitleViewController.h"
#import "ReportDetailsViewController.h"

@interface TitleViewController ()

@end

@implementation TitleViewController

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
    
    self.clientName.text = self.audit.client.companyName;
    
    self.date.text = self.audit.client.auditDate;
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"MM/dd/yyyy"];
//    
//    NSDate *date = [formatter dateFromString:self.audit.client.auditDate];
//    
//    NSLog(@"%@",date);
//    
//    [self.datePicker setDate:date];
//    
//TODO: wire up the date picker so it changes based on the text field and the other way around

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if ([viewController isKindOfClass:[TitleViewController class]]) {
        ReportDetailsViewController *rdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportDetailsViewController"];
        return  rdvc;
        
    }
    
    else return nil;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToDetails"]) {
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        
        [reportVC.finalPFDView addSubview:self.titlePdfView];
        [reportVC.finalPFDView sizeToFit];
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
     self.audit.client.companyName = self.clientName.text;
    
     self.audit.client.auditDate = self.date.text;

    
    //add view to other view
    //TODO: save audit
}
- (IBAction)datePickerValueChanged:(id)sender {
}
@end
