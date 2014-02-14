//
//  AnswersViewController.m
//  DNV
//
//  Created by USI on 1/9/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "AnswersViewController.h"
#import "ElementSubElementViewController.h"
#import "helpTextViewController.h"
#import "NotesViewController.h"
#import "CalculatorViewController.h"
#import "LayeredQuestion.h"
#import "VerifyPopOverViewController.h"
#import "VerifyTabController.h"
#import "Flurry.h"
#import "ImagePopOverViewController.h"
#import "AttachmentsPopOverViewController.h"

@interface AnswersViewController ()

{
    UIPopoverController * attachPop;
    bool showAttach;
}
@end


//Change this to go from big swith to table view for bool questions
BOOL const useSlider = true;

float pointTotal = 0.0;
BOOL answered = false; //used for submit button logic
BOOL keyboardShouldMove = false;

BOOL islayeredQuestion = false;
int subLayerPosition = 0;

Questions *mainSubQuestion;
Questions *unchangedQuestion;

int mainQuestionPosition;
BOOL isSublayeredQuestion = false;

int numOfSubs;




@implementation AnswersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewWillDisappear:(BOOL)animated
{
    self.question = unchangedQuestion;

}
- (void)viewDidLoad
{
    self.allSublayeredQuestions = [NSMutableArray new];
    
    NSLog(@"Questions: %@",self.question.questionText);
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.dnvDBManager = [DNVDatabaseManagerClass getSharedInstance];
    
//TODO: remove this
//temporary creating an audit to test with
 //   NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

   // NSString *auditID = [NSString stringWithFormat:@"%@.%@.%@", [defaults objectForKey:@"currentClient"], [defaults objectForKey:@"currentAudit"], [defaults objectForKey:@"currentUser"]];
    
   // self.audit = [self.dnvDBManager retrieveAudit:@"GeneralElectricIncorporated.BBS-DRAFT.1234"];
    
    
    if (self.question == nil || self.questionArray == nil)
    {
        NSLog(@"***SHOULD NOT GET HERE***, (recieved a nil question from previous VC)");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    self.questionNumberTextField.delegate = self;
    
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextButtonPushed:)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousButtonPushed:)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeLeftGestureRecognizer];
    [self.view addGestureRecognizer:swipeRightGestureRecognizer];

    [self.thumbsDownButton setImage:[UIImage imageNamed:@"thumbs_down.png"] forState:UIControlStateSelected];
    [self.thumbsDownButton setImage:[UIImage imageNamed:@"thumbs_down_gray.png"] forState:UIControlStateNormal];
    
    [self.thumbsUpButton setImage:[UIImage imageNamed:@"thumbs_up.png"] forState:UIControlStateSelected];
    [self.thumbsUpButton setImage:[UIImage imageNamed:@"thumbs_up_gray.png"] forState:UIControlStateNormal];
    
    //Switchy
    if (useSlider){
        if (self.switchy == nil) {
            self.switchy = [[KLSwitch alloc]initWithFrame:CGRectMake(280, 670, 160, 96)];
        }
    
    [self.view addSubview:self.switchy];
 //   [self.switchy setOnTintColor: [UIColor colorWithWhite:.85 alpha:.5]];
    
    [self.switchy setOn: NO animated: YES];
    
        __weak typeof(self) weakSelf = self;
    [self.switchy setDidChangeHandler:^(BOOL isOn) {
        NSLog(@"Switchy changed to %d", isOn);
        answered = true;
        Answers *leftAns;
        Answers *rightAns;
        if (weakSelf.ansArray.count >=2){
            leftAns = weakSelf.ansArray[1];
            rightAns = weakSelf.ansArray[0];
        }
        
        
        
        if (isOn) {
            rightAns.isSelected = true;
            leftAns.isSelected = false;
            pointTotal = rightAns.pointsPossible;
            weakSelf.pointsLabel.text = [NSString stringWithFormat:@"%.2f",pointTotal];
            [weakSelf setEnabledFlagsAndReloadQuestions];
        }
        else{
            leftAns.isSelected = true;
            rightAns.isSelected = true;
            pointTotal = leftAns.pointsPossible;
            weakSelf.pointsLabel.text = [NSString stringWithFormat:@"%.2f",pointTotal];
            [weakSelf setEnabledFlagsAndReloadQuestions];
        }

//        if (islayeredQuestion)
//        {
//            if (pointTotal >= self.question.pointsNeededForLayered)
//            {
//                [self.subQuesionsTableView setAllowsSelection:true];
//            }
//            else
//            {
//                [self.subQuesionsTableView setAllowsSelection:false];
//                [self.subQuesionsTableView deselectRowAtIndexPath:[self.subQuesionsTableView indexPathForSelectedRow] animated:YES];
//                
//            }
//         
//        }
        
    }];
    }
    if ([self.question.layeredQuesions count] > 0)
    {
        islayeredQuestion = true;
        mainSubQuestion = self.question;
        mainQuestionPosition = self.currentPosition;
        NSLog(@"%i.%i.%i   %@", self.elementNumber +1,self.subElementNum +1 , self.currentPosition+1, mainSubQuestion.questionText);
        
        
        self.mainLayeredQuesionButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.mainLayeredQuesionButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.mainLayeredQuesionButton.titleLabel.minimumScaleFactor = 0.5;
        self.mainLayeredQuesionButton.titleLabel.numberOfLines = 5;
       
        
        [self.mainLayeredQuesionButton setTitle:[NSString stringWithFormat:@"%@",mainSubQuestion.questionText] forState:UIControlStateNormal];
        //[allSublayeredQuestions addObject:self.question];
        
        numOfSubs = [self getNumOfSubQuestionsAndSetAllSubsArray:self.question layerDepth:0];
        
        NSLog(@"%d",numOfSubs);
        
        self.subQuesionsTableView.hidden = false;
    }
    
    
    else
    {
        islayeredQuestion = false;
        self.layeredQuestionsView.hidden = true;
        
    }
    
    [self refreshAnswerView];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    if (keyboardShouldMove){
        
    //Assign new frame to your view
    CGRect frame =  self.view.frame;
    
    //TODO: change hardcoded value
    frame.origin.y = -264;
    
    [self.view setFrame:frame];
    }
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    //Assign new frame to your view
    CGRect frame =  self.view.frame;
    
    //TODO: change hardcoded value
    frame.origin.y = 0;
    
    [self.view setFrame:frame];
}

#pragma mark View Changes

-(void)hideAnswerViews
{
    self.tableCell.hidden = true;
    self.answersTableView.hidden = true;
    self.percentSliderTextField.hidden = true;
    self.percentSlider.hidden = true;
    self.layeredQuestionsView.hidden = true;
    //self.subQuesionsTableView.hidden = true;
    self.questionText.hidden = true;

    answered = false;
    
    [self.firstButton setEnabled:true];
    [self.lastButton setEnabled:true];
    [self.nextButton setEnabled:true];
    [self.previousButton setEnabled:true];
    
    
    if (self.question.isCompleted) {
        pointTotal = self.question.pointsAwarded;
    }else
    {
        pointTotal = 0;
        
    }
    


    
//    if (self.question.questionType == 3) {
//        pointTotal = self.question.pointsAwarded;
//    }
    
   // self.pointsLabel.text = @"0";
    if (self.question.questionType == 2) {
        self.percentSlider.value = self.question.pointsAwarded / (self.question.pointsPossible/100);
        self.percentSliderTextField.text = [NSString stringWithFormat:@"%.2f", self.question.pointsAwarded];
    }
    else if(self.question.questionType == 4)
    {
        self.percentSlider.value = self.question.pointsAwarded;
        self.percentSliderTextField.text = [NSString stringWithFormat:@"%.2f", self.question.pointsAwarded];

    }
    
    self.pointsLabel.text =[NSString stringWithFormat:@"%.2f", self.question.pointsAwarded]; // @"0";

    
    //self.percentSlider.value = 0;
    //self.percentSliderTextField.text = @"";
    
    if (useSlider){
        self.leftSliderLabel.hidden = true;
        self.rightSliderLabel.hidden = true;
        self.switchy.hidden = true;
        if (self.question.questionType == 0) {
            float temp = self.question.pointsAwarded;
            [self.switchy setOn:temp>0];
        }
        
    }
    if (self.question.layeredQuesions.count >0) {
  //      pointTotal = self.question.pointsAwarded;
        [self.switchy setOn:false];
    }
}

-(void) refreshAnswerView
{
    
    isSublayeredQuestion = (self.currentPosition <0);
    
    //seting the current question
    if (isSublayeredQuestion) {
        //we get here when a subquestion was selected

        self.currentPosition++;
        self.currentPosition *= -1;
        LayeredQuestion *tempLayered = [self.allSublayeredQuestions objectAtIndex:self.currentPosition];
        self.question = tempLayered.question;

        
        self.questionNumberTextField.text = [NSString stringWithFormat:@"%i",(self.currentPosition +1)];
        
    }
    else{
        self.question = [self.questionArray objectAtIndex:self.currentPosition];
        self.questionNumberTextField.text = [NSString stringWithFormat:@"%i",(self.currentPosition +1)];
    }
    
    
    if ([mainSubQuestion.layeredQuesions count] > 0) {
        islayeredQuestion = true;
    }
    else islayeredQuestion = false;
    
    
    self.ansArray =  self.question.Answers;

    //Track Flury Event
    NSString *idString = [NSString stringWithFormat:@"%d",self.question.questionID];
    
    NSDictionary *questionParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     idString, @"Question ID",
     self.question.questionText, @"Question",
     nil];
    
    [Flurry logEvent:@"Question Answered" withParameters:questionParams timed:YES];
    
    unchangedQuestion = [[Questions alloc]initWithQuestion:[self.question toDictionary]];
    
    
    [self hideAnswerViews];
    

    NSLog(@"Question Type: %i",self.question.questionType);
    
    //shows the certain answer parts based on question type
    switch (self.question.questionType) {
        case 0: //bool
            if (useSlider)
            {
                self.switchy.hidden = false;
                self.leftSliderLabel.hidden = false;
                self.rightSliderLabel.hidden = false;
                Answers *leftAns = self.ansArray[1];
                Answers *rightAns =self.ansArray[0];
                self.leftSliderLabel.text = leftAns.answerText;
                self.rightSliderLabel.text = rightAns.answerText;
                self.questionText.hidden = NO;

            }
            else
            {
                self.answersTableView.hidden = false;
                self.answersTableView.allowsMultipleSelection = false;
                self.tableCell.hidden = false;
                self.questionText.hidden = NO;

            }
            break;
        case 1: //multiple choice
            self.answersTableView.hidden = false;
            self.answersTableView.allowsMultipleSelection = false;
            self.tableCell.hidden = false;
            self.questionText.hidden = NO;

            break;
        case 2: //percentage
            self.percentSlider.hidden = false;
            self.percentSliderTextField.hidden = false;
            self.percentSlider.maximumValue = 100.0;
            self.percentSlider.minimumValue = 0;
            self.questionText.hidden = NO;
            self.percentSliderTextField.text = [NSString stringWithFormat:@"%.2f %%", self.percentSlider.value];


            break;
        case 3: //partial
            self.answersTableView.hidden = false;
            self.answersTableView.allowsMultipleSelection = true;
            self.tableCell.hidden = false;
            self.questionText.hidden = NO;

            break;
        case 4: //professional Judgement
            self.percentSlider.hidden = false;
            self.percentSliderTextField.hidden = false;
            self.percentSlider.maximumValue = self.question.pointsPossible;
            self.percentSlider.value = self.question.pointsAwarded;
            self.questionText.hidden = NO;
            self.percentSliderTextField.text = [NSString stringWithFormat:@"%i", (int) self.percentSlider.value];

            
            break;
        default:
            NSLog(@"Should never get here!! Questions type incorrect");
            break;
    }//switch
    
    self.questionText.text = self.question.questionText;
    self.questionText.numberOfLines = 0;
    [self.questionText sizeToFit];
    
    
    [self.answersTableView reloadData];
    
   // self.questionNumLabel.text = [NSString stringWithFormat:@"%i.%i.%i", self.elementNumber +1,self.subElementNum +1 , self.currentPosition+1];
    
    if (isSublayeredQuestion) {
        [self.lastButton setEnabled:false];
        [self.nextButton setEnabled:false];
        [self.firstButton setEnabled:false];
        [self.previousButton setEnabled:false];
    }
    else{
        if (self.currentPosition == [self.questionArray count]-1) {
            
            [self.lastButton setEnabled:false];
            [self.nextButton setEnabled:false];
        }
        if (self.currentPosition == 0) {
            
            [self.firstButton setEnabled:false];
            [self.previousButton setEnabled:false];
        }
    }
    
    [self.thumbsUpButton setSelected:self.question.isThumbsUp];
    [self.thumbsDownButton setSelected:self.question.isThumbsDown];
    [self.naButton setSelected:!self.question.isApplicable];
    [self.verifyButton setSelected:self.question.needsVerifying];
    
    if ((isSublayeredQuestion) || self.question.layeredQuesions.count >0){
        
        self.layeredQuestionsView.hidden = false;
        
            NSArray *indexesToTurnOn = [NSArray new];
            
            for (int i = 0; i < [self.allSublayeredQuestions count]; i++)
            {
                LayeredQuestion *tempLayQ = [self.allSublayeredQuestions objectAtIndex:i];
                
                if ( [self.question.questionText isEqualToString:tempLayQ.question.questionText]) {
                    indexesToTurnOn = tempLayQ.subIndexes;
                }
            }
            
            for (int i=0; i<[indexesToTurnOn count];i++)
            {
                NSNumber *currInd = [indexesToTurnOn objectAtIndex:i];
                LayeredQuestion *tempLayQ = [self.allSublayeredQuestions objectAtIndex:[currInd intValue]];
                
                //int currentIndex = (int)[indexesToTurnOn objectAtIndex:i];
                
                //LayeredQuestion *tempLayQ = [allSublayeredQuestions objectAtIndex:currentIndex];
                
                tempLayQ.shouldBeEnabled = (pointTotal >= self.question.pointsNeededForLayered) || (self.question.pointsAwarded >= self.question.pointsNeededForLayered);
                
                [self.allSublayeredQuestions replaceObjectAtIndex:[currInd intValue] withObject:tempLayQ];
                
                
                [self.subQuesionsTableView reloadData];
            }
    }
    
    [self setNeedsVerifying:self.question.needsVerifying];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Delegate Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.answersTableView) {
        static NSString *simpleTableIdentifier = @"AnswerCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        Answers *ans = [self.ansArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = ans.answerText;
        
//        [cell setSelected:ans.isSelected];
        if (ans.isSelected && self.question.isCompleted) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        
        
        return cell;
    }
    else if (tableView == self.subQuesionsTableView)
    {
        if ( islayeredQuestion || isSublayeredQuestion)
        {
            
            static NSString *simpleTableIdentifier = @"subQuestionCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            LayeredQuestion *tempLayered = [self.allSublayeredQuestions objectAtIndex:indexPath.row];
            
            Questions * subQuest = tempLayered.question;
            
            cell.textLabel.text =[NSString stringWithFormat: @"%@", subQuest.questionText];
            cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:24];
            cell.textLabel.numberOfLines = 0;
            [cell.textLabel sizeToFit];
            cell.textLabel.minimumScaleFactor = 0.75;
            
            if (tempLayered.shouldBeEnabled) {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                [cell setUserInteractionEnabled:YES];
                cell.textLabel.enabled = YES;
            }
            else{
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.enabled = NO;
                [cell setUserInteractionEnabled:NO];

            }

            
            return cell;
            
        }
        
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subQuestionCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subQuestionCell"];
    }
    cell.textLabel.text = @" Should never see this";
    return cell;
    

}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.subQuesionsTableView)
    {
        LayeredQuestion *tempLayered = [self.allSublayeredQuestions objectAtIndex:indexPath.row];
    
        Questions * subQuest = tempLayered.question;
        
        // Get the text so we can measure it
        NSString *text = subQuest.questionText;
        // Get a CGSize for the width and, effectively, unlimited height
        CGSize constraint = CGSizeMake(740, 20000.0f);
        // Get the size of the text given the CGSize we just made as a constraint
        CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Verdana" size:24.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        //how to use this??
       // CGSize size2 = [text boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(NSDictionary *)#> context:<#(NSStringDrawingContext *)#>]
        
        // Get the height of our measurement, with a minimum of 44 (standard cell size)
        CGFloat height = MAX(size.height, 44.0f);
        // return the height, with a bit of extra padding in
        return height + 44;
    }
    
    else return  44.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.answersTableView) {
        
        return [self.ansArray count];
    }
    
    if (tableView == self.subQuesionsTableView) {

        return [self.allSublayeredQuestions count];
        
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.answersTableView) {
        Answers *ans = [self.ansArray objectAtIndex:indexPath.row];
        
        if (self.question.questionType == 0 ||self.question.questionType == 1)
        {
            pointTotal = 0;
        }
        
        pointTotal += ans.pointsPossible;
        
        self.pointsLabel.text =[NSString stringWithFormat:@"%.2f",pointTotal];
        
        [ans setIsSelected:true];
        
        answered = true;//used for submit button logic
        [self setEnabledFlagsAndReloadQuestions];
    }
    
    else if ( tableView == self.subQuesionsTableView)
    {
        LayeredQuestion *tempQ = [self.allSublayeredQuestions objectAtIndex:indexPath.row];
        self.question = tempQ.question;
        
        self.currentPosition = (indexPath.row +1) * -1;

        [self refreshAnswerView];
        
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.answersTableView) {
        Answers *ans = [self.ansArray objectAtIndex:indexPath.row];
        
        pointTotal -= ans.pointsPossible;
        
        self.pointsLabel.text =[NSString stringWithFormat:@"%.2f",pointTotal];
        [ans setIsSelected:false];
        
        [self setEnabledFlagsAndReloadQuestions];
        
    }
}

#pragma mark IBactions

- (IBAction)submitButton:(id)sender {
    
    if (!answered && self.question.questionType == 1) {
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"No answer" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    
    if (![self checkZeroDependencies] && pointTotal>0)//returns true if dependencies are met, false if they conflict
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Dependencies not met" message: @"Please check help notes" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![self checkLessOrEqualToDependency:pointTotal]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Dependencies not met" message: @"Please check help notes" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [Flurry endTimedEvent:@"Question Answered" withParameters:nil];
    
    if (self.question.isApplicable) {self.question.pointsAwarded = pointTotal;}
    
    
    else {
        self.question.isThumbsDown = false;
        self.question.isThumbsUp = false;
        self.question.needsVerifying =false;
        self.question.pointsAwarded = 0;
        pointTotal = 0;
        //set fields for all sub questions for this question to NA
        NSMutableArray *tempSubs = self.allSublayeredQuestions;
        //temporary changing allSubLays
        self.allSublayeredQuestions = [NSMutableArray new];
        int throwAway = [self getNumOfSubQuestionsAndSetAllSubsArray:self.question layerDepth:0];
        for (int i = 0 ; i < self.allSublayeredQuestions.count; i++) {
            LayeredQuestion *layQ = [self.allSublayeredQuestions objectAtIndex:i];
            layQ.question.isApplicable = false;
            self.question.isThumbsDown = false;
            self.question.isThumbsUp = false;
            self.question.needsVerifying =false;
            self.question.pointsAwarded = 0;
            [self.dnvDBManager updateQuestion:layQ.question];
        }
        //set allSubLays back to what it was
        self.allSublayeredQuestions = tempSubs;
    }
    
    self.question.isCompleted = true;

    //Update DNV Database
    [self.dnvDBManager updateQuestion:self.question];
    
    if (islayeredQuestion && (pointTotal >= self.question.pointsNeededForLayered )&& !(isSublayeredQuestion) &&(self.question ==mainSubQuestion)) {
        //main question answered to show subs so go to first subquestion
       
        [self.subQuesionsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        LayeredQuestion *tempQ = [self.allSublayeredQuestions objectAtIndex:0];
        tempQ.shouldBeEnabled = YES;
        [self.allSublayeredQuestions replaceObjectAtIndex:0 withObject:tempQ];
        
        self.question = tempQ.question;
        self.currentPosition = -1;
        [self refreshAnswerView];
        return;
    }
    if (islayeredQuestion && !(isSublayeredQuestion) && self.question.layeredQuesions.count >0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Skipped %d questions", [self.allSublayeredQuestions count] + self.currentPosition] message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        for (LayeredQuestion *layQ in self.allSublayeredQuestions) {
            layQ.question.pointsAwarded = 0;
            layQ.question.isCompleted = NO;
            for (Answers *ans in layQ.question.Answers) {
                ans.isSelected = NO;
            }
            [self.dnvDBManager updateQuestion:layQ.question];
        }
        
    }
    if (islayeredQuestion && isSublayeredQuestion) {
        int layeredPosition;
        if (self.currentPosition == 0) {
            layeredPosition = -1;
        }
        else
        {
            layeredPosition = (self.currentPosition +1) *-1 ;
        }
        //submit pushed with a sublayer question
        
        //mainSubQuestion.pointsAwarded += self.question.pointsAwarded;
        [self.dnvDBManager updateQuestion:mainSubQuestion];

        //check if last sublayered question
        if (layeredPosition == (-1* [self.allSublayeredQuestions count])) {
            
            self.currentPosition = mainQuestionPosition;
            if (self.currentPosition == ([self.questionArray count]-1))
            {
                //at the last sublayerd question which is also the last question in subelement
                //pop 2 view controllers
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:NO];
            }
            else{
                self.currentPosition++;
                [self refreshAnswerView];
                return;
            }
            
        }
        else //not last subquestion so go to next one if points are correct
        {
            NSLog(@"%d",layeredPosition);
            layeredPosition--;
            //check points awarded >= points needed for layered
            if (self.question.pointsAwarded >= self.question.pointsNeededForLayered) {
                
                [self.subQuesionsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:(layeredPosition +1)*-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                self.currentPosition = layeredPosition;
                [self refreshAnswerView];
                return;
                
            }
            else //point awarded < pointsNeededForLayered so go to next question in subLayereds
            {
                int posOfNextQuestion = layeredPosition;
                posOfNextQuestion = ((posOfNextQuestion +1)*-1);
                int i = posOfNextQuestion;
                for (; i<self.allSublayeredQuestions.count; i++) {
                    LayeredQuestion *layQ = [self.allSublayeredQuestions objectAtIndex:i];
                    
                    if (layQ.shouldBeEnabled) {
                        
                        [self.subQuesionsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                        self.currentPosition = (i+1)*-1;
                        [self refreshAnswerView];
                        return;
                        
                    }

                }
                //looped through allSubs but did not find an enabled question so go to next main question and show alert view saying how many questions skipped
                
                //get correct Layered Question were on to show number of skipped questions
                /*
                int layQPos;
                if (layeredPosition == -1) {
                    layQPos = 0;
                }else layQPos = ((layeredPosition +2) *-1);
                
                LayeredQuestion *layQ = [self.allSublayeredQuestions objectAtIndex:layQPos];
                //this only shows first layer number of skipped
                //need to loop thru the question
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Skipped %d questions", layQ.subIndexes.count] message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                */
                
                self.currentPosition = mainQuestionPosition;
                if (self.currentPosition == ([self.questionArray count]-1))
                {
                    //at the last sublayerd question which is also the last question in subelement
                    //pop 2 view controllers
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:NO];
                }
                else{
                    self.currentPosition++;
                    [self refreshAnswerView];
                    return;
                }
            }
            
        }
    }
    
    if (self.currentPosition == ([self.questionArray count]-1))
    {
        //pop 2 view controllers
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:NO];
    }
    else{
        self.currentPosition++;
        [self refreshAnswerView];
        return;
    }
}

- (IBAction)sliderChanged:(id)sender {
    if (self.question.questionType == 2)
    {
        self.percentSliderTextField.text = [NSString stringWithFormat:@"%.2f %%", self.percentSlider.value];
        self.pointsLabel.text = [NSString stringWithFormat:@"%.2f", (self.percentSlider.value * self.question.pointsPossible/100)];
    }
    if (self.question.questionType == 4) {
        self.pointsLabel.text = [NSString stringWithFormat:@"%i", (int) self.percentSlider.value];
        self.percentSliderTextField.text = [NSString stringWithFormat:@"%i", (int) self.percentSlider.value];
        
    }
    self.question.pointsAwarded = [self.pointsLabel.text floatValue];
    pointTotal = self.question.pointsAwarded;
    [self setEnabledFlagsAndReloadQuestions];
    
    answered = true;
}

- (IBAction)lastButtonPushed:(id)sender {
    self.question = unchangedQuestion;
    self.currentPosition = [self.questionArray count]-1;
    [self refreshAnswerView];
}

- (IBAction)firstButtonPushed:(id)sender {
    self.question = unchangedQuestion;
    
    self.currentPosition = 0;
    [self refreshAnswerView];

}

- (IBAction)nextButtonPushed:(id)sender {
    if (self.nextButton.enabled)
    {
        self.question = unchangedQuestion;
        self.currentPosition++;
        [self refreshAnswerView];
    }
}

- (IBAction)previousButtonPushed:(id)sender {
    
    if (self.previousButton.enabled) {
        self.question = unchangedQuestion;
        self.currentPosition--;
        [self refreshAnswerView];
    }
}


#pragma mark UITextField Delegate

-(IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
    keyboardShouldMove = true;
    textField.text = @"";
    
}

- (IBAction)textFieldEndedEditing:(id)sender {
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.questionNumberTextField){

    //check if out of bounds
    NSNumber *tempInt = [NSNumber numberWithInt:[self.questionNumberTextField.text intValue]];
    
    if (tempInt==nil || tempInt.intValue < 1 || tempInt.intValue > [self.questionArray count]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Out of range" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    self.currentPosition = tempInt.intValue - 1;
    [textField resignFirstResponder];
    [self refreshAnswerView];
    
    }
    else if (textField == self.percentSliderTextField)
    {

        [self percentTextChanged:nil];
        
    }
    return YES;
}

#pragma mark - Dashboard Buttons

- (IBAction)thumbsUpPushed:(id)sender {
    self.question.isThumbsUp = !self.question.isThumbsUp;
    [self.thumbsUpButton setSelected: !self.thumbsUpButton.selected];

}

- (IBAction)thumbsDownPushed:(id)sender {
    self.question.isThumbsDown = !self.question.isThumbsDown;
    [self.thumbsDownButton setSelected: !self.thumbsDownButton.selected];
}

- (IBAction)naButtonPushed:(id)sender {
    
    //This is off for now to test NA flows since isRequired is true for all questions in the bbsDraft audit
    /*
    Elements *tempEle = [self.audit.Elements objectAtIndex:self.elementNumber];
    if (tempEle.isRequired) {
        self.question.isApplicable = true;
        [self.naButton setSelected:false];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Question must be applicable" message: @"Element is required" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
     */
    self.question.isApplicable = !self.question.isApplicable;
    [self.naButton setSelected: !self.naButton.selected];
    
   
    if (self.question.isApplicable) {
        
    }
}

- (IBAction)verifyButtonPushed:(id)sender
{
    VerifyPopOverViewController *verifyPop = [self.storyboard instantiateViewControllerWithIdentifier:@"verifyPop"];
        
        // Pass the information to destination VC
        verifyPop.theAnswersVC = self;
        
        self.verifyPopOver.delegate = self;
        self.verifyPopOver= [[UIPopoverController alloc] initWithContentViewController:verifyPop];
    
    [verifyPop.btnGoToVerifyTabBar setHidden:self.cameFromVerifyTabBar];
    
    [self.verifyPopOver presentPopoverFromRect:self.verifyButton.frame inView:self.viewDashboard permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    
}
-(void)setNeedsVerifying: (int)vSelected 
{
    if( vSelected == 0) //0 implies none of the tabs where toggled on
    {
        [self.verifyButton setSelected: false];
    }
    else    //!0 implies atleast one of the tabs was toggled on
    {
        [self.verifyButton setSelected: true];
    }
}

- (IBAction)percentTextChanged:(id)sender {
    if (self.question.questionType == 2) {
        float value = [self.percentSliderTextField.text floatValue];
        if (value < 0) value = 0;
        if (value > 100) value = 100;
        self.percentSlider.value = value;
        self.percentSliderTextField.text = [NSString stringWithFormat:@"%.2f %%", value];
        self.pointsLabel.text = [NSString stringWithFormat:@"%.2f", (self.percentSlider.value * self.question.pointsPossible/100)];
        
    }
    
    else if (self.question.questionType == 4) {
        int value = [self.percentSliderTextField.text intValue];
        if (value < 0) value = 0;
        if (value > self.percentSlider.maximumValue) value = self.percentSlider.maximumValue;
        self.percentSlider.value = value;
        self.percentSliderTextField.text = [NSString stringWithFormat:@"%i", value];
        self.pointsLabel.text = [NSString stringWithFormat:@"%i", value];
        
    }
    self.question.pointsAwarded = [self.pointsLabel.text floatValue];

    answered = true;
    if ([self.percentSliderTextField canResignFirstResponder]) [self.percentSliderTextField resignFirstResponder];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.questionNumberTextField)
    {
        //check if out of bounds
        NSNumber *tempInt = [NSNumber numberWithInt:[self.questionNumberTextField.text intValue]];
        
        if (tempInt==nil || tempInt.intValue < 1 || tempInt.intValue > [self.questionArray count]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Out of range" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        self.currentPosition = tempInt.intValue - 1;
        
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if( textField == self.percentSliderTextField)
    {
        if( [string intValue] == 0 && ![string isEqualToString:@"0"] && [string length] > 0 )
        {
            return NO;
        }
    }
    
    return YES;
}

- (IBAction)calculatorButtonPushed:(id)sender {
    keyboardShouldMove = false;

    CalculatorViewController * calcVC = [self.storyboard instantiateViewControllerWithIdentifier:@"calcVC"];

    self.calcPopOver.delegate = self;
    calcVC.ansVC = self;
    
    self.calcPopOver= [[UIPopoverController alloc] initWithContentViewController:calcVC];
    
    [self.calcPopOver presentPopoverFromRect:self.calculatorButton.frame inView:self.viewDashboard  permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)cameraButtonPushed:(id)sender {
   // [self takePicture];
    
}

- (IBAction)attachmentButtonPushed:(id)sender {
    
    NSString *dataPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Attachments"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *arrayFiles = [fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@",dataPath] error:&error];
    
    if( ([arrayFiles count] == 0 || arrayFiles == nil) && ([self.question.attachmentsLocationArray count] == 0 || self.question.attachmentsLocationArray == nil) )
    {
        UIAlertView *noAttachments = [[UIAlertView alloc] initWithTitle:@"No attachments!" message:@"The app currently has no selectable attachments. To attach files form outside the app, you must use the open in feature of iOS, and open in DNV-GL app." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [noAttachments show];
        
        
    }
    else
    {
        AttachmentsPopOverViewController  * attPop = [self.storyboard instantiateViewControllerWithIdentifier:@"attachPop"];
        
        attachPop.delegate = self;
        attPop.question = self.question;
        attPop.myAnswersVC = self;
        
        attachPop= [[UIPopoverController alloc] initWithContentViewController:attPop];
        
        //  self.modalPresentationStyle = UIModalPresentationFullScreen;
        [attachPop presentPopoverFromRect:self.btnAttach.frame inView:self.viewDashboard  permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (IBAction)helpButtonPushed:(id)sender {
    
    [Flurry logEvent:@"Help Button Pushed"];
    
    //[self performSegueWithIdentifier:@"helpTextPopover" sender:sender];
}

- (IBAction)notesButtonPushed:(id)sender {
    
    keyboardShouldMove = false;
    //[self performSegueWithIdentifier:@"notesPopover" sender:sender];

}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ( [identifier isEqualToString:@"imagePopover"] )
    {
            NSString *dataPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Attachments"];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error = nil;
            NSArray *arrayFiles = [fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@",dataPath] error:&error];
            
            if( ([arrayFiles count] == 0 || arrayFiles == nil) && ([self.question.attachmentsLocationArray count] == 0 || self.question.attachmentsLocationArray == nil) )
            {
                UIAlertView *noAttachments = [[UIAlertView alloc] initWithTitle:@"No attachments!" message:@"The app currently has no selectable attachments. To attach files form outside the app, you must use the open in feature of iOS, and open in DNV-GL app." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [noAttachments show];
                
                return NO;
            }
    }
        
    return YES;
}
    
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"helpTextPopover"]) {
        
        // Get destination view
        helpTextViewController * destVC = [segue destinationViewController];
        
        // Pass the information to your destination view
        destVC.text = self.question.helpText;
    }
    
    if ([[segue identifier] isEqualToString:@"notesPopover"]) {
        
        // Get destination view
        NotesViewController * destVC = [segue destinationViewController];
        
        // Pass the information to your destination view
        [destVC setText:self.question.notes];
        [destVC setQuestion:self.question];
    }
    
    if ([[segue identifier] isEqualToString:@"questionToVerify"]) {
        
        // Get destination tabbar
        VerifyTabController * destVC = [segue destinationViewController];
        
        // Pass the information to your destination view
        destVC.theQuestion = self.question;
        
        //remove editQuestion button
        destVC.navigationItem.rightBarButtonItem = nil;
    }
    if ([[segue identifier] isEqualToString:@"imagePopover"]) {
        
        // Get destination tabbar
        ImagePopOverViewController * destVC = [segue destinationViewController];
        
        // Pass the information to your destination view
        destVC.question = self.question;

    }
    
    if([[segue identifier] isEqualToString:@"attachPopOver"]) {
        
        // Get destination tabbar
         AttachmentsPopOverViewController *attPopOver = [segue destinationViewController];
        
        // Pass the information to your destination view
        attPopOver.question = self.question;
    }
}





- (IBAction)mainLayeredPushed:(id)sender {
    isSublayeredQuestion = false;
    self.question = mainSubQuestion;
    self.currentPosition = mainQuestionPosition;
    [self.subQuesionsTableView deselectRowAtIndexPath:[self.subQuesionsTableView indexPathForSelectedRow] animated:YES];
    [self refreshAnswerView];
    
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
-(void)setEnabledFlagsAndReloadQuestions{
//pointTotal should be updated before calling this method
    
    if (mainSubQuestion == self.question) {
        for (Questions *subQuestion in self.question.layeredQuesions) {
            for (int i = 0; i < [self.allSublayeredQuestions count]; i++)
            {
                LayeredQuestion *layQuest = [self.allSublayeredQuestions objectAtIndex:i];
                if ([subQuestion.questionText isEqualToString:layQuest.question.questionText]) {
                    [layQuest setShouldBeEnabled:(pointTotal >= self.question.pointsNeededForLayered)];
                    [self.allSublayeredQuestions replaceObjectAtIndex:i withObject:layQuest];
                }
                
            }
        }
        [self.subQuesionsTableView reloadData];
    }
    else
    {
        NSArray *indexesToTurnOn = [NSArray new];
        
        //set shouldBeEnabled=true for all sub questions
        for (LayeredQuestion *layQuest in self.allSublayeredQuestions) {
            if ([layQuest.question.questionText isEqualToString:self.question.questionText]) {
                indexesToTurnOn = layQuest.subIndexes;
            }
        }
        for (int i=0; i<[indexesToTurnOn count];i++)
        {
            NSNumber *currInd = [indexesToTurnOn objectAtIndex:i];
            LayeredQuestion *tempLayQ = [self.allSublayeredQuestions objectAtIndex:[currInd intValue]];
            [tempLayQ setShouldBeEnabled:(pointTotal >= self.question.pointsNeededForLayered)];
            [self.allSublayeredQuestions replaceObjectAtIndex:[currInd intValue] withObject:tempLayQ];
            
        }
        [self.subQuesionsTableView reloadData];
    }

}
-(BOOL)checkZeroDependencies{ //returns true if dependencies are met, false if they conflict
    BOOL allGood = true;

    //temp test
   // NSArray *tempArr = @[@[@"1.1.1",@"2.3.4"],@"1.3.4",@"12.3",@"1.2.1"];
    //NSMutableArray *tempMutArray = [NSMutableArray arrayWithArray:tempArr];
    
    
  //  self.question.zeroIfNoPointsFor = tempMutArray;

    if( self.question.zeroIfNoPointsFor.count >0)
    {
        BOOL outterOR = false;
        
        NSNumber *eleNum;
        NSNumber *subEleNum;
        NSNumber *questNum;
        
        NSArray *array = self.question.zeroIfNoPointsFor;
        
        for(int i=0; i<[array count]; i++){
            
            if ([[array objectAtIndex:i] isKindOfClass: [NSArray class]])
            {//object at i is an array so use AND logic
                
                BOOL innerAnd = true; //true until it get sets to false
                NSArray *innerArray = [array objectAtIndex:i];
                for(int j=0; j<[innerArray count]; j++)
                {
                    NSString *str = [innerArray objectAtIndex:j];
                    
                    NSArray *chunks = [str componentsSeparatedByString: @"."];
                    //[zeroIF:xxx] returns true if xxx is 0, false otherwise
                    switch (chunks.count) {
                        case 1:
                            //element dependency
                            eleNum = chunks[0];
                            innerAnd = (innerAnd && [self zeroIf:eleNum]);
                            break;
                        case 2:
                            //subElement dependency
                            eleNum = chunks[0];
                            subEleNum = chunks[1];
                            innerAnd =  (innerAnd && [self zeroIf:eleNum subEle:subEleNum]);
                            break;
                        case 3:
                            //question dependency
                            eleNum = chunks[0];
                            subEleNum = chunks[1];
                            questNum = chunks[2];
                            innerAnd = (innerAnd && [self zeroIf:eleNum subEle:subEleNum question:questNum]);
                            break;
                            
                        default:
                            NSLog(@"Dependency messed up");
                            break;
                    }//inner and switch
                }

            }
            else{//object at i is a string so use OR logic
                NSString *str = [array objectAtIndex:i];
                NSArray *chunks = [str componentsSeparatedByString: @"."];
                switch (chunks.count) {
                    case 1:
                        //element dependency
                        eleNum = chunks[0];
                        //[zeroIF:xxx] returns true if xxx is 0, false otherwise
                        outterOR = (outterOR || [self zeroIf:eleNum]);
                        break;
                    case 2:
                        //subElement dependency
                        eleNum = chunks[0];
                        subEleNum = chunks[1];
                        outterOR = (outterOR || [self zeroIf:eleNum subEle:subEleNum]);
                        break;
                    case 3:
                        //question dependency
                        eleNum = chunks[0];
                        subEleNum = chunks[1];
                        questNum = chunks[2];
                        outterOR = (outterOR || [self zeroIf:eleNum subEle:subEleNum question:questNum]);
                        break;
                        
                    default:
                        NSLog(@"Dependency messed up");
                        break;
                }//switch
                
            }//else
            
            
        }//outer for
        allGood =  outterOR ;
        
        
    }//if zeroIfnoPoints
    
    
    
    return allGood;
}

-(BOOL)zeroIf:(NSNumber*)eleNum{
    Elements *ele = [self.audit.Elements objectAtIndex:([eleNum intValue]-1)];
    
    if (ele.pointsAwarded == 0) {
        return true;
    }
    return false;
}
-(BOOL)zeroIf:(NSNumber*)eleNum subEle:(NSNumber*)subEleNum{
    Elements *ele = [self.audit.Elements objectAtIndex:([eleNum intValue]-1)];
    SubElements *subEle = [ele.Subelements objectAtIndex:([subEleNum intValue]-1)];
    if (subEle.pointsAwarded == 0) {
        return true;
    }
    return false;
}
-(BOOL)zeroIf:(NSNumber*)eleNum subEle:(NSNumber*)subEleNum question:(NSNumber*)questNum{
    //Elements *ele = [self.audit.Elements objectAtIndex:([eleNum intValue]-1)];
    //SubElements *subEle = [ele.Subelements objectAtIndex:([subEleNum intValue]-1)];
    //Questions *question = [subEle.Questions objectAtIndex:([questNum intValue] -1)];
    // ^ this would have worked if not for sublayer questions (dam those sublayers)
    
    NSArray *allQuestionsFromSubelement = [self getAllQuestionsFromEle:[eleNum intValue] andSubEle:[subEleNum intValue]];
    
    //NSString *eleSubQuestNum = [NSString stringWithFormat:@"%@.%@.%@",eleNum,subEleNum,questNum];
    
    //not using element since the example JSON does not use the element number anywhere
    
    //TODO: change this if going to be using element number in question text 1.8.1 vs 8.1
    NSString *eleSubQuestNum = [NSString stringWithFormat:@"%@.%@",subEleNum,questNum];
    
    for (Questions *question in allQuestionsFromSubelement) {
        
        NSString *string = question.questionText;
        if ([string rangeOfString:eleSubQuestNum].location == NSNotFound) {
            //NSLog(@"string does not contain bla");
        } else {
            NSLog(@"Found question");
            
            if (question.pointsAwarded == 0) {
                return true;
            }
            else return false;
        }
        
    }
    NSLog(@"ERROR: was not able to find question.");
    
    return false;
    
}

-(BOOL) checkLessOrEqualToDependency:(float)points
{
    
    if( self.question.lessOrEqualToSmallestAnswer.count >0)
    {
//        BOOL outterOR = false;
        
        NSNumber *eleNum;
        NSNumber *subEleNum;
        NSNumber *questNum;
        
        NSArray *array = self.question.lessOrEqualToSmallestAnswer;
        
        NSMutableArray *pointsArray = [NSMutableArray new];
        
        for(int i=0; i<[array count]; i++){
            
            if ([[array objectAtIndex:i] isKindOfClass: [NSArray class]])
            {//object at i is an array so use AND logic
                
                NSArray *innerArray = [array objectAtIndex:i];
                for(int j=0; j<[innerArray count]; j++)
                {
                    NSString *str = [innerArray objectAtIndex:j];
                    
                    NSArray *chunks = [str componentsSeparatedByString: @"."];
                    //[getPoints] returns points from position
                    //and means what? points must be greater than all of the end ones???
                    switch (chunks.count) {
                        case 1:
                            //element dependency
                            eleNum = chunks[0];
                            [pointsArray addObject:[self getPoints:eleNum]];
                            break;
                        case 2:
                            //subElement dependency
                            eleNum = chunks[0];
                            subEleNum = chunks[1];
                            [pointsArray addObject:[self getPoints:eleNum subEle:subEleNum]];
                            break;
                        case 3:
                            //question dependency
                            eleNum = chunks[0];
                            subEleNum = chunks[1];
                            questNum = chunks[2];
                            [pointsArray addObject:[self getPoints:eleNum subEle:subEleNum question:questNum]];
                            break;
                            
                        default:
                            NSLog(@"Dependency messed up");
                            break;
                    }//inner and switch
                }
                
            }
            else{//object at i is a string so use OR logic
                NSString *str = [array objectAtIndex:i];
                NSArray *chunks = [str componentsSeparatedByString: @"."];
                switch (chunks.count) {
                    case 1:
                        //element dependency
                        eleNum = chunks[0];
                        [pointsArray addObject:[self getPoints:eleNum]];
                        break;
                    case 2:
                        //subElement dependency
                        eleNum = chunks[0];
                        subEleNum = chunks[1];
                        [pointsArray addObject:[self getPoints:eleNum subEle:subEleNum]];
                        break;
                    case 3:
                        //question dependency
                        eleNum = chunks[0];
                        subEleNum = chunks[1];
                        questNum = chunks[2];
                        [pointsArray addObject:[self getPoints:eleNum subEle:subEleNum question:questNum]];
                        break;
                        
                    default:
                        NSLog(@"Dependency messed up");
                        break;
                }//switch
                
            }//else
            
            
        }//outer for
        
        //get min from pointsArray
        float minValue = MAX_POS_FLOAT32;
        for (NSNumber *num in pointsArray) {
            if ( [num floatValue]<= minValue)
                minValue = [num floatValue];
        }
        
        if (points <= minValue) {
            return true;
        }
        else return false;
        
        
    }//if lessOrEqualToSmallestAnswer.count
    
    return true;
    
    
}
-(NSNumber*) getPoints:(NSNumber*)eleNum {
    Elements *ele = [self.audit.Elements objectAtIndex:([eleNum intValue]- 1)];
    NSNumber* point = [NSNumber numberWithFloat: ele.pointsAwarded];
    return point;
    
}

-(NSNumber*) getPoints:(NSNumber*)eleNum subEle:(NSNumber*)subEleNum
{
    Elements *ele = [self.audit.Elements objectAtIndex:([eleNum intValue]-1)];
    SubElements *subEle = [ele.Subelements objectAtIndex:([subEleNum intValue]-1)];
    NSNumber* point = [NSNumber numberWithFloat: subEle.pointsAwarded];
    return point;
}
-(NSNumber*) getPoints:(NSNumber*)eleNum subEle:(NSNumber*)subEleNum question:(NSNumber*)questNum{
    
    NSArray *allQuestionsFromSubelement = [self getAllQuestionsFromEle:[eleNum intValue] andSubEle:[subEleNum intValue]];
    
    //NSString *eleSubQuestNum = [NSString stringWithFormat:@"%@.%@.%@",eleNum,subEleNum,questNum];
    
    //not using element since the example JSON does not use the element number anywhere
    
    //TODO: change this if going to be using element number in question text 1.8.1 vs 8.1
    NSString *eleSubQuestNum = [NSString stringWithFormat:@"%@.%@",subEleNum,questNum];
    
    for (Questions *question in allQuestionsFromSubelement) {
        
        NSString *string = question.questionText;
        if ([string rangeOfString:eleSubQuestNum].location == NSNotFound) {
            //NSLog(@"string does not contain bla");
        } else {
            NSLog(@"Found question");
            
            NSNumber* point = [NSNumber numberWithFloat: question.pointsAwarded];
            return point;
        }
        
    }
    NSLog(@"ERROR: was not able to find question.");
    
    return [NSNumber numberWithFloat:MAX_POS_FLOAT32];
    
}


-(NSArray*)getAllQuestionsFromEle:(int)eleNum andSubEle:(int)subEleNum
{
    Elements *ele = [self.audit.Elements objectAtIndex:(eleNum - 1)];
    SubElements *subEle = [ele.Subelements objectAtIndex:(subEleNum - 1)];
    
    NSMutableArray *allQuestionsAndLayeredQs = [NSMutableArray new];
    
    for (Questions *question in subEle.Questions) {
        [allQuestionsAndLayeredQs addObjectsFromArray:[self getAllQuestionsFromQuestion:question]];
    }
    
    return allQuestionsAndLayeredQs;

}
-(NSArray*)getAllQuestionsFromQuestion:(Questions*)question
{
    NSMutableArray *questionAndSubQuestions = [NSMutableArray new];
    
    [questionAndSubQuestions addObject:question];
    for (Questions *layerdQuestion in question.layeredQuesions) {
        [questionAndSubQuestions addObjectsFromArray:[self getAllQuestionsFromQuestion:layerdQuestion]];
    }
    return questionAndSubQuestions;
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return NO;
}



- (void)showAFile
{
    @try
    {
        QLPreviewController * preview = [[QLPreviewController alloc] init];
        preview.dataSource = self;
        [self presentViewController:preview animated:YES completion:nil];
    }
    @catch (NSException *exception)
    {
        //nslog(@"Exception caught: %@", exception);
    }
}

//// Quick Look methods, delegates and data sources...
#pragma mark QLPreviewControllerDelegate methods
- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item {
	
	return YES;
}


#pragma mark QLPreviewControllerDataSource methods
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller{
    return 1;
}

- (id <QLPreviewItem>) previewController: (QLPreviewController *) controller previewItemAtIndex: (NSInteger) index
{
    NSString *dataPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Attachments"];
    
    showAttach = true;

    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",dataPath, self.chosenFile]];
}
////

@end
