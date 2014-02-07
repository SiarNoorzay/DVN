//
//  TableofContentsViewController.m
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "TableofContentsViewController.h"
#import "ReportDocViewController.h"

@interface TableofContentsViewController ()

@end

@implementation TableofContentsViewController

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
    if ([[segue identifier] isEqualToString:@"goToMethodology"]) {
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        
        //set the frame of this view to the bottom of the finalPdfview
//        CGRect rect = self.tableOfConPDFView.frame;
//        rect.origin.y = reportVC.finalPFDView.frame.size.height;
//        self.tableOfConPDFView.frame = rect;
        
        //[reportVC.viewArray addObject:self.tableOfConPDFView];
        
        [reportVC.viewArray setObject:self.tableOfConPDFView atIndexedSubscript:3];
        
       // [reportVC.finalPFDView addSubview:self.tableOfConPDFView];
       // [reportVC.finalPFDView sizeToFit];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
