//
//  ElementSubelementProfilesViewController.m
//  DNV
//
//  Created by USI on 1/24/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ElementSubelementProfilesViewController.h"
#import "ProfileLabelCell.h"
#import "ReportDocViewController.h"
#import "Profile.h"
#import "LayeredQuestion.h"
#import "ListOfCompletedViewController.h"

@interface ElementSubelementProfilesViewController ()


@end

@implementation ElementSubelementProfilesViewController
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
// adjust this following value to account for the height of your toolbar, too
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 262;
float animatedDistance2 = 0;

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
    for (int i=0; i<self.thumbedQuestions.count; i++) {
        Profile *prof = [self.thumbedQuestions objectAtIndex:i];
        NSString *notes = prof.text;
        notes = [notes stringByReplacingOccurrencesOfString:@"<insert text here>\n" withString:@""];
        prof.text = notes;
        Questions *quest = prof.question;
        if (quest) {
            NSString *notes = quest.notes;
            notes = [notes stringByReplacingOccurrencesOfString:@"<insert text here>\n" withString:@""];
            quest.notes = notes;
            [self.dnvDBManager updateQuestion:quest];

        }
    }
    [self.resultsTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.thumbedQuestions = [[NSMutableArray alloc]initWithCapacity:1];
    self.dnvDBManager = [DNVDatabaseManagerClass getSharedInstance];
    
    
    for (int i = 0; i<[self.audit.Elements count]; i++) {
        Elements *ele = [self.audit.Elements objectAtIndex:i];
        Profile *eleProf = [Profile new];
        eleProf.text = [NSString stringWithFormat:@"%d %@\n<insert text here>\n",i+1, ele.name];
        [self.thumbedQuestions addObject:eleProf];
        
        for (int j = 0; j<[ele.Subelements count]; j++) {
            SubElements *subEle = [ele.Subelements objectAtIndex:j];
            Profile *subEleProf = [Profile new];
            subEleProf.text = [NSString stringWithFormat:@"\t%d.%d %@\n<insert text here>\n",i+1,j+1, subEle.name];
            [self.thumbedQuestions addObject:subEleProf];
            
            NSMutableArray *upArray = [[NSMutableArray alloc]initWithCapacity:1];
            NSMutableArray *downArray = [[NSMutableArray alloc]initWithCapacity:1];
        
            for (int k = 0; k<[subEle.Questions count]; k++) {
                Questions *question = [subEle.Questions objectAtIndex:k];
                
                if (question.isThumbsUp) {
                    Profile *questProf = [Profile new];
                    questProf.question = question;
                    questProf.text = [NSString stringWithFormat:@"<insert text here>\n%d.%d.%d\n%@",i+1,j+1,k+1, question.notes];
                    [upArray addObject: questProf];
                    
//                    NSString *insert = @"<insert text here>\n";
//                    insert = [insert stringByAppendingString:question.notes];
//                    question.notes = insert;
//                    [self.thumbedQuestions addObject:question];
                }
                if (question.isThumbsDown) {
                    Profile *questProf = [Profile new];
                    questProf.question = question;
                    questProf.text = [NSString stringWithFormat:@"<insert text here>\n%d.%d.%d\n%@",i+1,j+1,k+1, question.notes];
                    [downArray addObject: questProf];
                    
//                    NSString *insert = @"<insert text here>\n";
//                    insert = [insert stringByAppendingString:question.notes];
//                    question.notes = insert;
//                    [self.thumbedQuestions addObject:question];

                }
                
                if ([question.layeredQuesions count] >0) {
                    self.allSublayeredQuestions = [NSMutableArray new];
                    [self getNumOfSubQuestionsAndSetAllSubsArray:question layerDepth:0];
                    //loop through all sub questions <need allsubs>
                    for (int l = 0; l<[self.allSublayeredQuestions count]; l++) {
                        LayeredQuestion *temp = [self.allSublayeredQuestions objectAtIndex:l];
                        Questions *layQuest = temp.question;
                        
                        if (layQuest.isThumbsUp) {
                            Profile *questProf = [Profile new];
                            questProf.question = layQuest;
                            questProf.text = [NSString stringWithFormat:@"<insert text here>\n%d.%d.%d.%d\n%@",i+1,j+1,k+1,l+1, layQuest.notes];
                            [upArray addObject: questProf];
                            
                            //                    NSString *insert = @"<insert text here>\n";
                            //                    insert = [insert stringByAppendingString:question.notes];
                            //                    question.notes = insert;
                            //                    [self.thumbedQuestions addObject:question];
                        }
                        if (question.isThumbsDown) {
                            Profile *questProf = [Profile new];
                            questProf.question = layQuest;
                            questProf.text = [NSString stringWithFormat:@"<insert text here>\n%d.%d.%d.%d\n%@",i+1,j+1,k+1,l+1,layQuest.notes];
                            [downArray addObject: questProf];
                            
                            //                    NSString *insert = @"<insert text here>\n";
                            //                    insert = [insert stringByAppendingString:question.notes];
                            //                    question.notes = insert;
                            //                    [self.thumbedQuestions addObject:question];
                       
                        }
                }//layered question
            }//question
                
        }//loop sub element
            if ([upArray count]>0)
            {
                Profile *noteWorthy = [Profile new];
                noteWorthy.text = [NSString stringWithFormat:@"\t\tNoteworthy Efforts"];
                [self.thumbedQuestions addObject: noteWorthy];
                for (Profile *ups in upArray)
                {
                    [self.thumbedQuestions addObject:ups];
                }
                
            }
            if ([downArray count]>0)
            {
                Profile *suggsForImprov = [Profile new];
                suggsForImprov.text = [NSString stringWithFormat:@"\t\tSuggesstions for Improvement "];
                [self.thumbedQuestions addObject:suggsForImprov];
                for (Profile *downs in downArray)
                {
                    [self.thumbedQuestions addObject:downs];
                }
                
            }
        }
        
            
    }//loop element

    for (int i = 0; i<self.thumbedQuestions.count; i++) {
        Profile *temp = [self.thumbedQuestions objectAtIndex:i];
        NSLog(@"%d %d: %@\n",i,temp.question==nil,temp.text);
    }
    self.parentView = self.profilesPDFView;
    
    [self.resultsTableView reloadData];
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    //Questions *quest =[self.thumbsDowndQuestions objectAtIndex:indexPath.row];
    Profile *temp = [self.thumbedQuestions objectAtIndex:indexPath.row];
    if (temp.question !=nil)
    {
        NSString *label = temp.text;
        
        CGSize stringSize = [label sizeWithFont:[UIFont fontWithName:@"Verdana" size:14]
                              constrainedToSize:CGSizeMake(492, 9999)
                                  lineBreakMode:NSLineBreakByWordWrapping];
        
        return stringSize.height+40;
    }
   // + add;
    
    else return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"ProfileLabelCell";
    
    ProfileLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if(cell == nil){
        cell = [[ProfileLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Profile *cellProf = [self.thumbedQuestions objectAtIndex:indexPath.row];
    cell.notesTextView.text = cellProf.text;
    cell.notesTextView.delegate = self;
    
    if (cellProf.question !=nil)
    {
        NSString *label = cell.notesTextView.text;
        
        CGSize stringSize = [label sizeWithFont:[UIFont fontWithName:@"Verdana" size:14]
                              constrainedToSize:CGSizeMake(492, 9999)
                                  lineBreakMode:NSLineBreakByWordWrapping];
        if (stringSize.height <59) {
            stringSize.height = 59;
        }
        CGRect rect = cell.notesTextView.frame;
        rect.size.height =  stringSize.height ;
        rect.size.width = 492;
        rect.origin.x =80;
        cell.notesTextView.frame = rect;
        cell.notesTextView.selectable = NO;
        cell.userInteractionEnabled = YES;
        [cell.notesTextView setEditable:YES];
        
    }else //regular label
    {
        CGRect rect = cell.notesTextView.frame;
        rect.size.height = 59;
        rect.size.width = 572;
        rect.origin.x = 0;
        cell.notesTextView.frame = rect;
        cell.notesTextView.selectable = NO;
        cell.userInteractionEnabled = YES;
        [cell.notesTextView setEditable:YES];
        
        //this changes behavior of noteworthy and suggesstions cells
//        if ((([cell.notesTextView.text rangeOfString:@"\t\tNoteworthy Efforts"].location != NSNotFound)) || ([cell.notesTextView.text rangeOfString:@"\t\tSuggesstions for Improvement "].location != NSNotFound)) {
//            cell.notesTextView.selectable = NO;
//            cell.userInteractionEnabled = YES;
//            [cell.notesTextView setEditable:YES];
//        }
    }

    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.thumbedQuestions count];
    
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
        Profile *prof = [self.thumbedQuestions objectAtIndex:indexPath.row];
        Questions *quest = prof.question;
        NSString *notes = quest.notes;
        notes = [notes stringByReplacingOccurrencesOfString:@"<insert text here>\n" withString:@""];
        quest.notes = notes;
        notes = prof.text;
        notes = [notes stringByReplacingOccurrencesOfString:@"<insert text here>\n" withString:@""];
        prof.text = notes;
        
        [self.thumbedQuestions removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    NSLog(@"Deleted row.");
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    ProfileLabelCell* cell = [self parentCellFor:textView];
    if (cell)
    {
        NSIndexPath* indexPath = [self.resultsTableView indexPathForCell:cell];
        if (indexPath !=nil) {
            [self textViewDidEndEditing:textView inRowAtIndexPath:indexPath];
            [self.resultsTableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];

        }
    }
    //[self.resultsTableView reloadData];
}
- (void)textViewDidBeginEditing:(UITextView*)textView
{
    ProfileLabelCell* cell = [self parentCellFor:textView];
    if (cell)
    {
        NSIndexPath* indexPath = [self.resultsTableView indexPathForCell:cell];
        [self.resultsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
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
    
    animatedDistance2 = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    
    CGRect viewFrame = self.parentView.frame;
    viewFrame.origin.y -= animatedDistance2;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.parentView setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        textView.contentOffset = CGPointMake(0.0, textView.contentSize.height);
        //textView.
    }
    return YES;
}
- (ProfileLabelCell*)parentCellFor:(UIView*)view
{
    if (!view)
        return nil;
    if ([view isMemberOfClass:[ProfileLabelCell class]])
        return (ProfileLabelCell*)view;
    return [self parentCellFor:view.superview];
}

- (void)textViewDidEndEditing:(UITextView*)textView inRowAtIndexPath:(NSIndexPath*)indexPath;
{
    Profile *cellProf = [self.thumbedQuestions objectAtIndex:indexPath.row];
    if(cellProf.question != nil)
    {
        cellProf.text = textView.text;
        CGRect rect = textView.frame;
        rect.size.height = textView.contentSize.height;
        textView.frame = rect;
        cellProf.question.notes = textView.text;
    }
    CGRect viewFrame = self.parentView.frame;
    viewFrame.origin.y += animatedDistance2;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.parentView setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToReportDoc"]) {
        
        ReportDocViewController * repVC = [segue destinationViewController];
        
        repVC.audit = self.audit;
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        
        int pixelsToMove = self.resultsTableView.frame.size.height;
        
        CGRect rect         = self.resultsTableView.frame;
        rect.size.height    = self.resultsTableView.contentSize.height;
        self.resultsTableView.frame  = rect;
        
        pixelsToMove = self.resultsTableView.frame.size.height - pixelsToMove;
        
        MergeClass *fixHeight = [MergeClass new];
        UILabel *someLabel = [[UILabel alloc] initWithFrame:CGRectMake( 50, self.lblProfilesTitle.frame.origin.y+self.lblProfilesTitle.frame.size.height+20, 572, 50)];
    
        for( int i=0; i<self.thumbedQuestions.count; i++)
        {
            someLabel.numberOfLines = 0;
            someLabel.font =[UIFont fontWithName:@"Verdana" size:14];
            Profile *prof = [self.thumbedQuestions objectAtIndex:i];
            Questions *currQuestion = prof.question;
            someLabel.text = [NSString stringWithFormat:@"%@",prof.text];
            int width = 572;
            int x = 0;
            if (currQuestion !=nil) {
                width = 492;
                x = 80;
            }
            CGSize stringSize = [someLabel.text sizeWithFont:[UIFont fontWithName:@"Verdana" size:14]
                                           constrainedToSize:CGSizeMake(width, 9999)
                                               lineBreakMode:NSLineBreakByWordWrapping];
            stringSize.height += 20;
            
            CGRect rect = someLabel.frame;
            rect.size = stringSize;
            rect.origin.x = x;
            
            someLabel.frame = rect;
            
            
            
            someLabel = (UILabel*)[fixHeight adjustSpaceForMyObject:someLabel];
            
            [self.profilesPDFView addSubview:someLabel];
            
            //            ySpacer +=
            someLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, someLabel.frame.origin.y + someLabel.frame.size.height +10, 572, 50)];
        }

        
        //make the pdfview height bigger
        rect = self.profilesPDFView.frame;
        rect.size.height += pixelsToMove;
       
        int numPages = ceil( rect.size.height / 792 );
        rect.size.height = numPages * 792;
        self.profilesPDFView.frame = rect;
        self.resultsTableView.hidden = YES;
        
        [reportVC.viewArray setObject:self.profilesPDFView atIndexedSubscript:9];

    }
}
-(int) getNumOfSubQuestionsAndSetAllSubsArray:(Questions *)question layerDepth:(int)depth
{
    int n = 1;
    for (int i = 0; i < [question.layeredQuesions count]; i++)
    {
        LayeredQuestion *tempObject = [LayeredQuestion new];
        
        tempObject.question = [question.layeredQuesions objectAtIndex:i];
        [self.allSublayeredQuestions addObject:tempObject];
        
        if( tempObject.question.layeredQuesions.count > 0)
            depth++;
        
        n += [self getNumOfSubQuestionsAndSetAllSubsArray:tempObject.question layerDepth:depth];
        
        tempObject.subIndexes = [NSMutableArray new];
        for( int j = 1; j <= tempObject.question.layeredQuesions.count; j++ )
        {
            
            [tempObject.subIndexes addObject:[NSNumber numberWithInt: j + [self.allSublayeredQuestions indexOfObject:tempObject] ] ];
        }
        
    }
    return n;
}

@end
