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
#import "ListOfCompletedViewController.h"

@interface KeySuggestionsViewController ()

@end

@implementation KeySuggestionsViewController
BOOL initialHeight = true;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
// adjust this following value to account for the height of your toolbar, too
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 262;
float animatedDistance = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    for (int i=0; i<self.thumbsDowndQuestions.count; i++) {
        Questions *quest = [self.thumbsDowndQuestions objectAtIndex:i];
        NSString *notes =quest.notes;
        notes = [notes stringByReplacingOccurrencesOfString:@"<insert text here>\n" withString:@""];
        quest.notes = notes;
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // self.audit = getAuditFromDB with ID from previous selection
    self.thumbsDowndQuestions = [[NSMutableArray alloc]initWithCapacity:1];
    self.positions = [[NSMutableArray alloc]initWithCapacity:1];

    self.parentView = self.KeySugsTableView;
    
    for (int i = 0; i< [self.audit.Elements count]; i++) {
        Elements *ele = [self.audit.Elements objectAtIndex:i];
        for (int j = 0; j<[ele.Subelements count];j++) {
            SubElements *subEle = [ele.Subelements objectAtIndex:j];
            for (int k = 0; k < [subEle.Questions count]; k++) {
                Questions *question =[subEle.Questions objectAtIndex:k];
                
                if (question.isThumbsDown) {
                    [self.thumbsDowndQuestions addObject:question];
                    [self.positions addObject:[NSString stringWithFormat:@"%d.%d.%d", i +1, j+1, k+1]];
                }
                if ([question.layeredQuesions count] >0)
                {
                    for (int l = 0; l < [question.layeredQuesions count]; l++)
                    {
                        Questions *subQuestion = [question.layeredQuesions objectAtIndex:l];
                        if (subQuestion.isThumbsDown) {
                            [self.thumbsDowndQuestions addObject:subQuestion];
                            [self.positions addObject:[NSString stringWithFormat:@"%d.%d.%d.%d", i +1, j+1, k+1,l+1]];
                            
                        }
                    }
                }//layered if
            }
            
        }
    }//outer most for loop
    
    for (int i = 0; i < [self.thumbsDowndQuestions count]; i++) {
        Questions *quest = [self.thumbsDowndQuestions objectAtIndex:i];
        
        NSLog(@" %@    %@",[self.positions objectAtIndex:i], quest.notes );
        NSString *insert = @"<insert text here>\n";
        insert = [insert stringByAppendingString:quest.notes];
        quest.notes = insert;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
 
    Questions *quest =[self.thumbsDowndQuestions objectAtIndex:indexPath.row];
    NSString *label = quest.notes;
    
    CGSize stringSize = [label sizeWithFont:[UIFont fontWithName:@"Verdana" size:18]
                          constrainedToSize:CGSizeMake(401, 9999)
                              lineBreakMode:NSLineBreakByWordWrapping];
    
    return stringSize.height+55;// + add;
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
    cell.notesTextView.delegate = self;
    cell.numberLabel.text = [self.positions objectAtIndex:indexPath.row];
    Questions *quest = [self.thumbsDowndQuestions objectAtIndex:indexPath.row];

    cell.notesTextView.text = quest.notes;
    
    
    NSString *label = cell.notesTextView.text;
    
    CGSize stringSize = [label sizeWithFont:[UIFont fontWithName:@"Verdana" size:18]
                          constrainedToSize:CGSizeMake(401, 9999)
                              lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect rect = cell.notesTextView.frame;
    rect.size.height =  stringSize.height + 44;
    cell.notesTextView.frame = rect;
    
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
        Questions *quest = [self.thumbsDowndQuestions objectAtIndex:indexPath.row];
        NSString *notes = quest.notes;
        notes = [notes stringByReplacingOccurrencesOfString:@"<insert text here>\n" withString:@""];
        quest.notes = notes;
        
        [self.positions removeObjectAtIndex:indexPath.row];
        [self.thumbsDowndQuestions removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    NSLog(@"Deleted row.");
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    KeySuggesstionCell* cell = [self parentCellFor:textView];
    if (cell)
    {
        NSIndexPath* indexPath = [self.KeySugsTableView indexPathForCell:cell];
        [self textViewDidEndEditing:textView inRowAtIndexPath:indexPath];
        if (indexPath!=nil) {
            [self.KeySugsTableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    initialHeight = false;
    
}

- (void)textViewDidBeginEditing:(UITextView*)textView
{
    KeySuggesstionCell* cell = [self parentCellFor:textView];
    if (cell)
    {
        NSIndexPath* indexPath = [self.KeySugsTableView indexPathForCell:cell];
        [self.KeySugsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    NSString *notes =textView.text;
    notes = [notes stringByReplacingOccurrencesOfString:@"<insert text here>\n" withString:@""];
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
    
    animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    
    CGRect viewFrame = self.parentView.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.parentView setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

//-(UIEdgeInsets) contentInset{
//    return UIEdgeInsetsZero;
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        textView.contentOffset = CGPointMake(0.0, textView.contentSize.height+20);
        //textView.
    }
    return YES;
}

- (KeySuggesstionCell*)parentCellFor:(UIView*)view
{
    if (!view)
        return nil;
    if ([view isMemberOfClass:[KeySuggesstionCell class]])
        return (KeySuggesstionCell*)view;
    return [self parentCellFor:view.superview];
}

- (void)textViewDidEndEditing:(UITextView*)textView inRowAtIndexPath:(NSIndexPath*)indexPath;
{
    Questions *quest = [self.thumbsDowndQuestions objectAtIndex:indexPath.row];
    quest.notes = textView.text;
    
    //[self.thumbsDowndQuestions replaceObjectAtIndex:indexPath.row withObject:textView.text];
    CGRect rect = textView.frame;
    rect.size.height = textView.contentSize.height;
    textView.frame = rect;
    
    CGRect viewFrame = self.parentView.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.parentView setFrame:viewFrame];
    
    [UIView commitAnimations];
    
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
        
        
        
         MergeClass *fixHeight = [MergeClass new];
        UILabel *someLabel = [[UILabel alloc] initWithFrame:CGRectMake( 50, self.lblKeysTitle.frame.origin.y+self.lblKeysTitle.frame.size.height+20, 600, 50)];
        
        for( int i=0; i<self.thumbsDowndQuestions.count; i++)
        {
            someLabel.numberOfLines = 0;
            someLabel.font =[UIFont fontWithName:@"Verdana" size:18];
            Questions *currQuestion = [self.thumbsDowndQuestions objectAtIndex:i];
            someLabel.text = [NSString stringWithFormat:@"%@ - %@", [self.positions objectAtIndex:i], currQuestion.notes];
//            [someLabel sizeToFit];
            
            CGSize stringSize = [someLabel.text sizeWithFont:[UIFont fontWithName:@"Verdana" size:18]
                                  constrainedToSize:CGSizeMake(600, 9999)
                                      lineBreakMode:NSLineBreakByWordWrapping];
            stringSize.height += 20;
            
            CGRect rect = someLabel.frame;
            rect.size = stringSize;
            
            someLabel.frame = rect;
            
            
            
            someLabel = (UILabel*)[fixHeight adjustSpaceForMyObject:someLabel];
            
            [self.keySugsPDFView addSubview:someLabel];
            
//            ySpacer +=
            someLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, someLabel.frame.origin.y + someLabel.frame.size.height +10, 600, 50)];
        }
        
        //make the pdfview height bigger
        rect = self.keySugsPDFView.frame;
        rect.size.height += pixelsToMove;
        
        int numPages = ceil( rect.size.height / 792 );
        rect.size.height = numPages * 792;
        
        self.keySugsPDFView.frame = rect;
        
        [reportVC.viewArray setObject:self.keySugsPDFView atIndexedSubscript:6];
        
    }
}

    
@end
