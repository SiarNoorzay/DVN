//
//  ReportDocViewController.m
//  DNV
//
//  Created by USI on 1/22/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ReportDocViewController.h"

@interface ReportDocViewController ()

@end

@implementation ReportDocViewController

static ReportDocViewController* _sharedReportDocViewController = nil;

+(ReportDocViewController*)sharedReportDocViewController
{
    @synchronized([ReportDocViewController class])
    {
        if (!_sharedReportDocViewController)
         _sharedReportDocViewController = [[self alloc] init];
        
        return _sharedReportDocViewController;
    }
    
    return nil;
}

- (id)init {
    if (self = [super init]) {
        self.finalPFDView = [[UIScrollView alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
