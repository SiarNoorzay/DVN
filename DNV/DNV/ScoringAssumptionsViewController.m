//
//  ScoringAssumptionsViewController.m
//  DNV
//
//  Created by USI on 1/24/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ScoringAssumptionsViewController.h"
#import "ReportDocViewController.h"
#import "ElementSubelementProfilesViewController.h"
#import "ListOfCompletedViewController.h"

@interface ScoringAssumptionsViewController ()

@end

@implementation ScoringAssumptionsViewController

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
    
    if (![self.audit.report.scoringAssumptions isEqualToString:@"(null)"])
    {
        self.scoreAssumpTextView.text = self.audit.report.scoringAssumptions;

    }
}
- (void)textViewDidBeginEditing:(UITextView*)textView
{
    NSString *notes =textView.text;
    notes = [notes stringByReplacingOccurrencesOfString:@"<change text here as needed>\n" withString:@""];
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
    if ([[segue identifier] isEqualToString:@"goToProfiles"]) {
        
        
        ElementSubelementProfilesViewController * eleProfVC = [segue destinationViewController];
        
        eleProfVC.audit = self.audit;
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        
        int pixelsToMove = self.scoreAssumpTextView.frame.size.height;
        
        CGRect rect         = self.scoreAssumpTextView.frame;
        rect.size.height    = self.scoreAssumpTextView.contentSize.height;
        self.scoreAssumpTextView.frame  = rect;
        
        pixelsToMove = self.scoreAssumpTextView.frame.size.height - pixelsToMove;
        
        //make the pdfview height bigger
        rect = self.scoringAsumPDFView.frame;
        rect.size.height += pixelsToMove;
        int numPages = ceil( rect.size.height / 792 );
        rect.size.height = numPages * 792;
        self.scoringAsumPDFView.frame = rect;
        
        [reportVC.viewArray setObject:self.scoringAsumPDFView atIndexedSubscript:8];
        
    }
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

-(void)viewDidDisappear:(BOOL)animated
{
    self.audit.report.scoringAssumptions = self.scoreAssumpTextView.text;
    
    //TODO: save audit back to DB
}



@end
