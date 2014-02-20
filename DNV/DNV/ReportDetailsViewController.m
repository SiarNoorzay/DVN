//
//  ReportDetailsViewController.m
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ReportDetailsViewController.h"
#import "ReportDocViewController.h"
#import "ExecutiveSummaryViewController.h"
#import "ListOfCompletedViewController.h"

@interface ReportDetailsViewController ()

@end

@implementation ReportDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSString *notes =textView.text;
    notes = [notes stringByReplacingOccurrencesOfString:@"<insert summary here>\n" withString:@""];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
     self.clientRef.text = self.audit.report.clientRef;
    self.summary.text = self.audit.report.summary;
    if ([self.summary.text isEqualToString:@""] || [self.summary.text isEqualToString:@"(null)"] || self.summary.text == nil)
    {
        self.summary.text = @"<insert summary here>";
        
    }
    self.preparedBy.text = self.audit.report.preparedBy;
    self.approvedBy.text = self.audit.report.approvedBy;
    self.dateOfIssue.text = self.audit.client.auditDate;
    self.projectNum.text = [NSString stringWithFormat:@"%@",self.audit.report.projectNum];
    
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

-(void)viewWillDisappear:(BOOL)animated
{
    self.audit.report.clientRef = self.clientRef.text;
    self.audit.report.summary = self.summary.text;
    self.audit.report.preparedBy = self.preparedBy.text;
    self.audit.report.approvedBy = self.approvedBy.text;
    self.audit.client.auditDate = self.dateOfIssue.text;
    self.audit.report.projectNum = self.projectNum.text; 
    
    //TODO:save audit
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToExecutiveSummary"]) {
        MergeClass *fixHeight = [MergeClass new];
        ExecutiveSummaryViewController * exeVC = [segue destinationViewController];
        
        exeVC.audit = self.audit;
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        
        int pixelsToMove = self.summary.frame.size.height;

        CGRect rect         = self.summary.frame;
        rect.size.height    = self.summary.contentSize.height;
        self.summary.frame  = rect;
        
        pixelsToMove = self.summary.frame.size.height - pixelsToMove;
        
        //make the hieght view bigger
        rect = self.reportDetialsPDFView.frame;
        rect.size.height += pixelsToMove;
        int numPages = ceil( rect.size.height / 792 );
        rect.size.height = numPages * 792;
        self.reportDetialsPDFView.frame = rect;
        
        //move each uiElement under the summary down
        rect = self.preparedBy.frame;
        rect.origin.y += pixelsToMove;
        self.preparedBy.frame = rect;
        self.preparedBy = (UITextField*)[fixHeight adjustSpaceForMyObject:self.preparedBy];
        
        rect = self.preparedByLabel.frame;
        rect.origin.y += pixelsToMove;
        self.preparedByLabel.frame = rect;
        self.preparedByLabel = (UILabel*)[fixHeight adjustSpaceForMyObject:self.preparedByLabel];
        
        
        rect = self.approvedBy.frame;
        rect.origin.y += pixelsToMove;
        self.approvedBy.frame = rect;
        self.approvedBy = (UITextField*)[fixHeight adjustSpaceForMyObject:self.approvedBy];
        
        rect = self.approvedByLabel.frame;
        rect.origin.y += pixelsToMove;
        self.approvedByLabel.frame = rect;
        self.approvedByLabel = (UILabel*)[fixHeight adjustSpaceForMyObject:self.approvedByLabel];
        
        rect = self.dateOfIssueLabel.frame;
        rect.origin.y += pixelsToMove;
        self.dateOfIssueLabel.frame = rect;
        self.dateOfIssueLabel = (UILabel*)[fixHeight adjustSpaceForMyObject:self.dateOfIssueLabel];
        
        rect = self.dateOfIssue.frame;
        rect.origin.y += pixelsToMove;
        self.dateOfIssue.frame = rect;
        self.dateOfIssue = (UITextField*)[fixHeight adjustSpaceForMyObject:self.dateOfIssue];
        
        rect = self.projectNum.frame;
        rect.origin.y += pixelsToMove;
        self.projectNum.frame = rect;
        self.projectNum = (UITextField*)[fixHeight adjustSpaceForMyObject:self.projectNum];
        
        rect = self.projectNumLabel.frame;
        rect.origin.y += pixelsToMove;
        self.projectNumLabel.frame = rect;
        self.projectNumLabel = (UILabel*)[fixHeight adjustSpaceForMyObject:self.projectNumLabel];
        
        rect = self.copyrightLabel.frame;
        rect.origin.y += pixelsToMove;
        self.copyrightLabel.frame = rect;
        self.copyrightLabel = (UILabel*)[fixHeight adjustSpaceForMyObject:self.copyrightLabel];
        
        //[reportVC.viewArray addObject:self.reportDetialsPDFView];
        [reportVC.viewArray setObject:self.reportDetialsPDFView atIndexedSubscript:1];

        
        //set the frame of this view to the bottom of the finalPdfview
        //rect = self.reportDetialsPDFView.frame;
       // rect.origin.y = reportVC.finalPFDView.frame.size.height;
       // self.reportDetialsPDFView.frame = rect;
        
      //  [reportVC.finalPFDView addSubview:self.reportDetialsPDFView];
       // [reportVC.finalPFDView sizeToFit];
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
