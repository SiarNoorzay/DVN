//
//  MethodologyViewController.m
//  DNV
//
//  Created by USI on 2/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "MethodologyViewController.h"
#import "ReportDocViewController.h"

@interface MethodologyViewController ()

@end

@implementation MethodologyViewController

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
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToConclusion"]) {
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        
        //set the frame of this view to the bottom of the finalPdfview
//        CGRect rect = self.methodPDFView.frame;
//        rect.origin.y = reportVC.finalPFDView.frame.size.height;
//        self.methodPDFView.frame = rect;
//        
//        
//        [reportVC.finalPFDView addSubview:self.methodPDFView];
//        [reportVC.finalPFDView sizeToFit];
//
       // [reportVC.viewArray addObject:self.methodPDFView];
        
        [reportVC.viewArray setObject:self.methodPDFView atIndexedSubscript:4];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
