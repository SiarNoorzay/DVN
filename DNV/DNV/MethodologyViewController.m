//
//  MethodologyViewController.m
//  DNV
//
//  Created by USI on 2/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "MethodologyViewController.h"
#import "ReportDocViewController.h"
#import "ConclusionViewController.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToConclusion"]) {
        ConclusionViewController * concVC = [segue destinationViewController];
        
        concVC.audit = self.audit;
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        
        //set the frame of this view to the bottom of the finalPdfview
        int pixelsToMove = self.methodSummary.frame.size.height;
        
        CGRect rect         = self.methodSummary.frame;
        rect.size.height    = self.methodSummary.contentSize.height;
        self.methodSummary.frame  = rect;
        
        pixelsToMove = self.methodSummary.frame.size.height - pixelsToMove;
        
        //make the pdfview height bigger
        rect = self.methodPDFView.frame;
        rect.size.height += pixelsToMove;
        int numPages = ceil( rect.size.height / 792 );
        rect.size.height = numPages * 792;
        self.methodPDFView.frame = rect;
        
//
//        
//        [reportVC.finalPFDView addSubview:self.methodPDFView];
//        [reportVC.finalPFDView sizeToFit];
//
       // [reportVC.viewArray addObject:self.methodPDFView];
        
        [reportVC.viewArray setObject:self.methodPDFView atIndexedSubscript:4];
    }
    
}
- (void)keyboardDidShow:(NSNotification *)notification
{
    //Assign new frame to your view
    CGRect frame =  self.view.frame;
    
    //TODO: change hardcoded value
    frame.origin.y = -264;
    
    [self.view setFrame:frame];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    //Assign new frame to your view
    CGRect frame =  self.view.frame;
    
    //TODO: change hardcoded value
    frame.origin.y = 0;
    
    [self.view setFrame:frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
