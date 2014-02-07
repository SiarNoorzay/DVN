//
//  KeySuggestionsViewController.m
//  DNV
//
//  Created by USI on 1/24/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "KeySuggestionsViewController.h"
#import "ReportDocViewController.h"
#import "SummaryOfRatingsViewController.h"

@interface KeySuggestionsViewController ()

@end

@implementation KeySuggestionsViewController


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
    self.thumbsDowndQuestions = [[NSMutableArray alloc]initWithCapacity:1];
    self.positions = [[NSMutableArray alloc]initWithCapacity:1];

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
    
    for (int i = 0; i< [self.audit.Elements count]; i++) {
        Elements *ele = [self.audit.Elements objectAtIndex:i];
        for (int j = 0; j<[ele.Subelements count];j++) {
            SubElements *subEle = [ele.Subelements objectAtIndex:j];
            for (int k = 0; k < [subEle.Questions count]; k++) {
                Questions *question =[subEle.Questions objectAtIndex:k];
                
                if (question.isThumbsDown) {
                    [self.thumbsDowndQuestions addObject:question.notes];
                    [self.positions addObject:[NSString stringWithFormat:@"%d.%d.%d", i +1, j+1, k+1]];
                }
                if ([question.layeredQuesions count] >0)
                {
                    for (int l = 0; l < [question.layeredQuesions count]; l++)
                    {
                        Questions *subQuestion = [question.layeredQuesions objectAtIndex:l];
                        if (subQuestion.isThumbsDown) {
                            [self.thumbsDowndQuestions addObject:subQuestion.notes];
                            [self.positions addObject:[NSString stringWithFormat:@"%d.%d.%d.%d", i +1, j+1, k+1,l+1]];
                            
                        }
                    }
                }
            }
            
        }
    }//outer most for loop
    
    for (int i = 0; i < [self.thumbsDowndQuestions count]; i++) {
        NSLog(@" %@    %@",[self.positions objectAtIndex:i], [self.thumbsDowndQuestions objectAtIndex:i] );
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.thumbsDowndQuestions count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"KeySuggesstionCell";
    
    KeySuggesstionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[KeySuggesstionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.numberLabel.text = [self.positions objectAtIndex:indexPath.row];
    cell.notesTextLabel.text = [self.thumbsDowndQuestions objectAtIndex:indexPath.row];
    
    return cell;
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.positions removeObjectAtIndex:indexPath.row];
        [self.thumbsDowndQuestions removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    NSLog(@"Deleted row.");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToRatings"]) {
        
        SummaryOfRatingsViewController * sumVC = [segue destinationViewController];
        
        sumVC.audit = self.audit;
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        [self.KeySugsTableView reloadData];
        
        [self.KeySugsTableView layoutIfNeeded];

        
        int pixelsToMove = self.KeySugsTableView.frame.size.height;
        
        CGRect rect         = self.KeySugsTableView.frame;
        rect.size.height    = self.KeySugsTableView.contentSize.height;
        self.KeySugsTableView.frame  = rect;
        
        pixelsToMove = self.KeySugsTableView.frame.size.height - pixelsToMove;
        
        if( pixelsToMove < 0)
            pixelsToMove = 0;
        
        //make the pdfview height bigger
        rect = self.keySugsPDFView.frame;
        rect.size.height += pixelsToMove;
        
        int numPages = ceil( rect.size.height / 792 );
        rect.size.height = numPages * 792;
        
        self.keySugsPDFView.frame = rect;
        
        
        //set the frame of this view to the bottom of the finalPdfview
//        rect = self.keySugsPDFView.frame;
//        rect.origin.y = reportVC.finalPFDView.frame.size.height;
//        self.keySugsPDFView.frame = rect;
//        
//        
//        [reportVC.finalPFDView addSubview:self.keySugsPDFView];
//        [reportVC.finalPFDView sizeToFit];
        
       // [reportVC.viewArray addObject:self.keySugsPDFView];
        [reportVC.viewArray setObject:self.keySugsPDFView atIndexedSubscript:6];
        

    }
    
}

    
@end
