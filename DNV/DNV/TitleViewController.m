//
//  TitleViewController.m
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "TitleViewController.h"
#import "ReportDetailsViewController.h"
#import "ListOfCompletedViewController.h"

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
    
    self.clientName.text = self.audit.client.companyName;
    
    self.date.text = self.audit.client.auditDate;
    
//TODO: wire up the date picker so it changes based on the text field and the other way around
    
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
        
        
        ReportDetailsViewController * detailsVC = [segue destinationViewController];
            
        detailsVC.audit = self.audit;
        
        
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        
       // [reportVC.finalPFDView addSubview:self.titlePdfView];
      //  [reportVC.finalPFDView sizeToFit];
        
        
        [reportVC.viewArray setObject:self.titlePdfView atIndexedSubscript:0];
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
     self.audit.client.companyName = self.clientName.text;
    
     self.audit.client.auditDate = self.date.text;

    //TODO: save audit
}
- (IBAction)datePickerValueChanged:(id)sender {
}
@end
