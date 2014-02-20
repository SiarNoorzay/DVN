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

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UITextRange *temp =[textView selectedTextRange];
    //CGPoint point = [textView caretRectForPosition:textView.textContainer.];
    
    int pos = [textView offsetFromPosition:textView.beginningOfDocument toPosition:temp.start];
    
    NSString *aStr = [textView.text substringToIndex:pos];
    //UITextPosition *newPos = [textView positionFromPosition:textView.endOfDocument offset:pos];
    
    CGSize stringSize = [aStr sizeWithFont:[UIFont fontWithName:@"Verdana" size:14]
                         constrainedToSize:CGSizeMake(textView.frame.size.width, 9999)
                             lineBreakMode:NSLineBreakByWordWrapping];
    
    int numberOfNewLines = ceil( 100 / textView.font.lineHeight );
    
    NSString *spacer = [NSString new];
    while (numberOfNewLines > 0) {
        spacer = [spacer stringByAppendingString:@"\n"];
        numberOfNewLines--;
    }
    
    if( (int)(stringSize.height + textView.frame.origin.y) % 742 > 692 )
    {
        
        
        aStr = [aStr stringByAppendingString:spacer];
        NSString *fromCurrentSpotOn = [textView.text substringFromIndex:pos];
        fromCurrentSpotOn = [fromCurrentSpotOn stringByReplacingOccurrencesOfString:spacer withString:@""];
        
        textView.text = [NSString stringWithFormat:@"%@%@%@", aStr, text, fromCurrentSpotOn];
        
        NSRange z = {pos+spacer.length+1, 0};
        [textView setSelectedRange:z];
        return NO;
    }
    else if( text.length > 0 )
    {
        NSString *fromCurrentSpotOn = [textView.text substringFromIndex:pos];
        NSString *builtString = [NSString new];
        
        NSRange spotOfSpacer = [fromCurrentSpotOn rangeOfString:spacer];
        
        if( (int)spotOfSpacer.length <= 0 )
            builtString = [builtString stringByAppendingString:fromCurrentSpotOn];
        
        while (spotOfSpacer.length > 0)
        {
            
            NSRange newSpot = {spotOfSpacer.location-1, spotOfSpacer.length};
            NSRange oneChar = {spotOfSpacer.location-1, 1};
            
            if( spotOfSpacer.location > 0)
            {
                fromCurrentSpotOn = [fromCurrentSpotOn stringByReplacingCharactersInRange:spotOfSpacer withString:@""];
                fromCurrentSpotOn = [fromCurrentSpotOn stringByReplacingCharactersInRange:newSpot withString:[NSString stringWithFormat:@"%@%@", spacer, [fromCurrentSpotOn substringWithRange:oneChar]]];
            }
            
            builtString = [NSString stringWithFormat:@"%@%@",builtString, fromCurrentSpotOn];
            
            fromCurrentSpotOn = [fromCurrentSpotOn substringFromIndex:spotOfSpacer.location+spacer.length+1];
            spotOfSpacer = [fromCurrentSpotOn rangeOfString:spacer];
        }
        
        textView.text = [NSString stringWithFormat:@"%@%@%@", aStr, text, builtString];
        
        NSRange z = {pos+text.length, 0};
        [textView setSelectedRange:z];
        
        return NO;
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
