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

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
// adjust this following value to account for the height of your toolbar, too
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 262;
float animatedDistance4 = 0;

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
    self.parentView = self.methodPDFView;

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
-(void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect viewFrame = self.parentView.frame;
    viewFrame.origin.y += animatedDistance4;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.parentView setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    
}
- (void)textViewDidBeginEditing:(UITextView*)textView
{
    
    NSString *notes =textView.text;
    notes = [notes stringByReplacingOccurrencesOfString:@"<insert text here>" withString:@""];
    textView.text = notes;
    
    
    CGRect textFieldRect = [self.parentView.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect = [self.parentView.window convertRect:self.parentView.bounds fromView:self.parentView];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    animatedDistance4 = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    
    CGRect viewFrame = self.parentView.frame;
    viewFrame.origin.y -= animatedDistance4;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.parentView setFrame:viewFrame];
    
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
