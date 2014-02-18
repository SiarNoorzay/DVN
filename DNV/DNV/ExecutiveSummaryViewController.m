//
//  ExecutiveSummaryViewController.m
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ExecutiveSummaryViewController.h"
#import "ReportDocViewController.h"
#import "TableofContentsViewController.h"

@interface ExecutiveSummaryViewController ()

@end

@implementation ExecutiveSummaryViewController

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
    
    
    if (![self.audit.report.executiveSummary isEqualToString:@"(null)"]) {
        self.executiveSummary.text = self.audit.report.executiveSummary;
    }
    
    if ([self.executiveSummary.text isEqualToString:@""] || [self.executiveSummary.text isEqualToString:@"(null)"] || self.executiveSummary.text ==nil)
    {
        self.executiveSummary.text = @"<insert summary here>";
        
    }
    
    self.auditCountLabel.text = [NSString stringWithFormat:@"The audit consisted of %i elements.",[self.audit.Elements count]];
    NSString *tempEleList = @"";
   // NSString *tempSubEleList = [NSString new];
    
    for (int i = 0; i < [self.audit.Elements count]; i++)
    {
        Elements *ele = [self.audit.Elements objectAtIndex:i];
        if (i==0) tempEleList = [tempEleList stringByAppendingString:[NSString stringWithFormat:@"%@, ", ele.name]];

            else tempEleList = [tempEleList stringByAppendingString:[NSString stringWithFormat:@"\n\n%@, ", ele.name]];

        tempEleList = [tempEleList stringByAppendingString:@"with Subelements: "];
        for (int j = 0; j< ele.Subelements.count; j++) {
            SubElements *sub = [ele.Subelements objectAtIndex:j];
            tempEleList = [tempEleList stringByAppendingString:[NSString stringWithFormat:@"%@ ", sub.name]];
        }
    }
//    Elements *ele = [self.audit.Elements objectAtIndex:[self.audit.Elements count]-1];
//    tempEleList = [tempEleList stringByAppendingString:[NSString stringWithFormat:@"%i (%@). ",[self.audit.Elements count], ele.name]];
//    SubElements *sub = [ele.Subelements objectAtIndex:[ele.Subelements.count]-1] ;
//    tempSubEleList = [tempSubEleList stringByAppendingString:[NSString stringWithFormat:@"%i <%@>",[ele.Subelements count], sub.name]];
    
    //NSAttributedString *atrString = [[NSAttributedString alloc]initWithString:tempEleList];
    
   
    self.elementList.text = tempEleList;
    

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToToC"]) {
        
        TableofContentsViewController * tocVC = [segue destinationViewController];
        
        tocVC.audit = self.audit;
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        
        int pixelsToMove = self.executiveSummary.frame.size.height;
        
        CGRect rect         = self.executiveSummary.frame;
        rect.size.height    = self.executiveSummary.contentSize.height;
        self.executiveSummary.frame  = rect;
        
        pixelsToMove = self.executiveSummary.frame.size.height - pixelsToMove;
        if (pixelsToMove<0)
            pixelsToMove = 0;
        
        //make the pdfview height bigger
        rect = self.executiveSumPDFView.frame;
        rect.size.height += pixelsToMove;
        self.executiveSumPDFView.frame = rect;
        
        //move each uiElement under the exe summary down
        rect = self.auditCountLabel.frame;
        rect.origin.y += pixelsToMove;
        self.auditCountLabel.frame = rect;
        
        rect = self.elementList.frame;
        rect.origin.y += pixelsToMove;
        self.elementList.frame = rect;
        
        
        //set height to content size of element list and update pdfview size accordingly
        
        int pixelsToMove2 = self.elementList.frame.size.height;
        rect = self.elementList.frame;
        rect.size.height    = self.elementList.contentSize.height;
        self.elementList.frame  = rect;
        
        pixelsToMove2 = self.elementList.frame.size.height - pixelsToMove2;
        
        if (pixelsToMove2<0)
            pixelsToMove2 = 0;
        
        //make the pdfview height bigger
        rect = self.executiveSumPDFView.frame;
        rect.size.height += pixelsToMove2;

        int numPages = ceil( rect.size.height / 792 );
        rect.size.height = numPages * 792;
        self.executiveSumPDFView.frame = rect;
        
       // [reportVC.viewArray addObject:self.executiveSummary];

        [reportVC.viewArray setObject:self.executiveSumPDFView atIndexedSubscript:2];
        
        //set the frame of this view to the bottom of the finalPdfview
//        rect = self.executiveSumPDFView.frame;
//        rect.origin.y = reportVC.finalPFDView.frame.size.height;
//        self.executiveSumPDFView.frame = rect;
        
        
       // [reportVC.finalPFDView addSubview:self.executiveSumPDFView];
       // [reportVC.finalPFDView sizeToFit];
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.audit.report.executiveSummary = self.executiveSummary.text;
    
    //TODO: save audit
}

@end
