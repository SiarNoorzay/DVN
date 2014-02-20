//
//  ConclusionViewController.m
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ConclusionViewController.h"
#import "ReportDocViewController.h"
#import "KeySuggestionsViewController.h"

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
    
    
//    NSError *error;
//    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleCompletedAudit" ofType:@"json"]];
//    
//    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
//    
//    NSLog(@"JSON contains:\n%@", [dictionary description]);
//    
//    NSDictionary *theAudit = [dictionary objectForKey:@"Audit"];
//    
//    self.audit = [[Audit alloc]initWithAudit:theAudit];
    
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
    
    if (!([self.audit.report.conclusion isEqualToString:@"(null)"] ||[self.audit.report.conclusion isEqualToString:@""])) {
        self.conclusionTextView.text = self.audit.report.conclusion;
    }
    else self.conclusionTextView.text = @"<insert text here>";
    
    
}
- (void)textViewDidBeginEditing:(UITextView*)textView
{
    NSString *notes =textView.text;
    notes = [notes stringByReplacingOccurrencesOfString:@"<insert text here>" withString:@""];
    textView.text = notes;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UITextRange *temp =[textView selectedTextRange];
    //CGPoint point = [textView caretRectForPosition:textView.textContainer.];
    
    int pos = [textView offsetFromPosition:textView.beginningOfDocument toPosition:temp.start];
    
    NSString *aStr = [textView.text substringToIndex:pos];
    //UITextPosition *newPos = [textView positionFromPosition:textView.endOfDocument offset:pos];
    
    CGSize stringSize = [aStr sizeWithFont:textView.font
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToKeySugs"]) {
        
        KeySuggestionsViewController * keySugsVC = [segue destinationViewController];
        
        keySugsVC.audit = self.audit;
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        
        int pixelsToMove = self.conclusionTextView.frame.size.height;
        
        CGRect rect         = self.conclusionTextView.frame;
        rect.size.height    = self.conclusionTextView.contentSize.height;
        self.conclusionTextView.frame  = rect;
        
        pixelsToMove = self.conclusionTextView.frame.size.height - pixelsToMove;
        
        //make the pdfview height bigger
        rect = self.conclusionPFDView.frame;
        rect.size.height += pixelsToMove;
        int numPages = ceil( rect.size.height / 792 );
        rect.size.height = numPages * 792;
        self.conclusionPFDView.frame = rect;
        
        
        //set the frame of this view to the bottom of the finalPdfview
//        rect = self.conclusionPFDView.frame;
//        rect.origin.y = reportVC.finalPFDView.frame.size.height;
//        self.conclusionPFDView.frame = rect;
//        
//        
//        [reportVC.finalPFDView addSubview:self.conclusionPFDView];
//        [reportVC.finalPFDView sizeToFit];
        
      //  [reportVC.viewArray addObject:self.conclusionPFDView];

        [reportVC.viewArray setObject:self.conclusionPFDView atIndexedSubscript:5];
        
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
