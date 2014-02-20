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
    
    // self.audit = getAuditFromDB with ID from previous selection
    
//    
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
    
    if ([self.audit.report.scoringAssumptions isEqualToString:@"(null)"]|| [self.audit.report.scoringAssumptions isEqualToString:@""])
    {
        self.scoreAssumpTextView.text = @"<change text here as needed>\nThe audit followed defined XXXXXXX procedures and was conducted as a base line audit. The audit interviews were conducted with individuals identified as having ""in depth"" knowledge of specific controls and systems. This information was then verified by follow-up interviews with line management and employees, and supporting documentation was reviewed. A ""Physical Condition Tour"" evaluation was also conducted to establish that controls were in place and working.\nA total of XXXXXXX employee interviews were carried out XXXXXXX, representing all departments of the organization. The sample was conducted in order to verify the implementation of the XXXXXXX system activities. Additional questions were asked about the employee perception of the Council Bluff safety system. The over-all impression is that employees feel safety is the number one priority at the site.\nThe Physical Conditions Tour is not a comprehensive inspection, but rather a sampling of typical workplace conditions which reflect upon the XXXXXXX system implemented at the site. The overall physical conditions throughout the plant were found to be in good order. Specifics of substandard conditions can be viewed on the Physical Condition sheet attached with the audit. The concerns the auditors found on the PCT was shared in the closing meeting with the management team.\nIn general, the XXXXXXX protocol requires that the practical application of program activities across the plant be reflected in policies and/or, procedures at a 75% compliance level. This “objective” requirement will not, therefore, recognise a number of plant activities due to there being insufficient documented procedures in place to reflect these practices. The practical application of some of the Company’s written procedures may also not have been able to be demonstrated sufficiently for credit to be awarded at this time. Generally, systems have to be in place and working for a minimum of 3 months in order to score in the audit. Therefore, activities carried on at the present level of implementation would likely result in a lower audit score.";
    }
    else
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
