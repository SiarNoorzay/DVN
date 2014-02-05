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

@interface AnswersViewController ()

@end



//Change this to go from big swith to table view for bool questions
BOOL const useSlider = true;

float pointTotal = 0.0;
BOOL answered = false; //used for submit button logic
BOOL keyboardShouldMove = false;

BOOL islayeredQuestion = false;
int subLayerPosition = 0;
Questions *mainSubQuestion;
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

- (void)viewDidLoad
{
    self.allSublayeredQuestions = [NSMutableArray new];
    
    NSLog(@"Questions: %@",self.question.questionText);
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.dnvDBManager = [DNVDatabaseManagerClass getSharedInstance];
    
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
            self.switchy = [[KLSwitch alloc]initWithFrame:CGRectMake(300, 615, 160, 96)];
        }
    
    [self.view addSubview:self.switchy];
 //   [self.switchy setOnTintColor: [UIColor colorWithWhite:.85 alpha:.5]];
    
    [self.switchy setOn: NO animated: YES];
    
    [self.switchy setDidChangeHandler:^(BOOL isOn) {
        NSLog(@"Switchy changed to %d", isOn);
        answered = true;
        Answers *leftAns;
        Answers *rightAns;
        if (self.ansArray.count >=2){
            leftAns = self.ansArray[1];
            rightAns = self.ansArray[0];
        }
        
        
        
        if (isOn) {
            rightAns.isSelected = true;
            leftAns.isSelected = false;
            pointTotal = rightAns.pointsPossible;
            self.pointsLabel.text = [NSString stringWithFormat:@"%.2f",pointTotal];
            [self setEnabledFlagsAndReloadQuestions];
        }
        else{
            leftAns.isSelected = true;
            rightAns.isSelected = true;
            pointTotal = leftAns.pointsPossible;
            self.pointsLabel.text = [NSString stringWithFormat:@"%.2f",pointTotal];
            [self setEnabledFlagsAndReloadQuestions];
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

    
    [self.firstButton setEnabled:true];
    [self.lastButton setEnabled:true];
    [self.nextButton setEnabled:true];
    [self.previousButton setEnabled:true];
    
    pointTotal = 0;
    self.pointsLabel.text = @"0";
    answered = false;
    self.percentSlider.value = 0;
    self.percentSliderTextField.text = @"";
    
    if (useSlider){
        self.leftSliderLabel.hidden = true;
        self.rightSliderLabel.hidden = true;
        self.switchy.hidden = true;
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
            self.percentSliderTextField.text = @"0%";


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
            self.percentSlider.value = 0;
            self.questionText.hidden = NO;
            self.percentSliderTextField.text = @"0";

            
            break;
        default:
            NSLog(@"Should never get here!! Questions type incorrect");
            break;
    }//switch
    self.questionText.text = self.question.questionText;
    [self.answersTableView reloadData];
    
    self.questionNumLabel.text = [NSString stringWithFormat:@"%i.%i.%i", self.elementNumber +1,self.subElementNum +1 , self.currentPosition+1];
    
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
        
        [cell setSelected:ans.isSelected];
        
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
            
            cell.textLabel.font = [UIFont systemFontOfSize:24];
            cell.textLabel.numberOfLines = 5;
            cell.textLabel.minimumScaleFactor = 0.75;
            
            cell.textLabel.text =[NSString stringWithFormat: @"%@", subQuest.questionText];
            
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
    self.question.isCompleted = true;
    self.question.pointsAwarded = pointTotal;
    //TODO: actually save stuff

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
        
        //check if last sublayered question
        if (layeredPosition == (-1* [self.allSublayeredQuestions count])) {
            
            self.currentPosition = mainQuestionPosition;
            if (self.currentPosition == ([self.questionArray count]-1))
            {
                //pop 2 view controllers
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:NO];
            }
            else{
//TODO: This else or the one after needs to be fixed.
                self.currentPosition++;
                //mainSubQuestion = [self.questionArray objectAtIndex:self.currentPosition];
                [self refreshAnswerView];
                return;
            }
            
        }
        else //not last subquestion so go to next one
        {
            NSLog(@"%d",layeredPosition);
            layeredPosition--;
            
            [self.subQuesionsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:(layeredPosition +1)*-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            LayeredQuestion *tempQ = [self.allSublayeredQuestions objectAtIndex:(layeredPosition +1 ) *-1];
            //self.question = tempQ.question;
            self.currentPosition = layeredPosition;
            [self refreshAnswerView];
            return;
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
    self.currentPosition = [self.questionArray count]-1;
    [self refreshAnswerView];
}

- (IBAction)firstButtonPushed:(id)sender {
    self.currentPosition = 0;
    [self refreshAnswerView];

}

- (IBAction)nextButtonPushed:(id)sender {
    if (self.nextButton.enabled)
    {
        self.currentPosition++;
        [self refreshAnswerView];
    }
}

- (IBAction)previousButtonPushed:(id)sender {
    
    if (self.previousButton.enabled) {
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
    self.question.isApplicable = !self.question.isApplicable;
    [self.naButton setSelected: !self.naButton.selected];
    
    if (self.question.isApplicable) {
        
    }
}

- (IBAction)verifyButtonPushed:(id)sender {
   // self.question.needsVerifying = !self.question.needsVerifying;
   // [self.verifyButton setSelected: !self.verifyButton.selected];
    
    //[self performSegueWithIdentifier:@"verifyPopOver" sender:sender];
        
        // Get destination view
        //VerifyPopOverViewController * verifyPop = [segue destinationViewController];
    
    VerifyPopOverViewController *verifyPop = [self.storyboard instantiateViewControllerWithIdentifier:@"verifyPop"];
        
        // Pass the information to destination VC
        verifyPop.theAnswersVC = self;
        
        self.verifyPopOver.delegate = self;
        self.verifyPopOver= [[UIPopoverController alloc] initWithContentViewController:verifyPop];
    
    [self.verifyPopOver presentPopoverFromRect:self.verifyButton.frame inView:self.viewDashboard permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    
}
-(void)setNeedsVerifying: (int)vSelected //to change/work with enum we had discussed
{
    if( vSelected == 0) //0 implies none of the tabs where toggled on
    {
        self.question.needsVerifying = false;
        [self.verifyButton setSelected: false];
    }
    else    //!0 implies atleast one of the tabs was toggled on
    {
        self.question.needsVerifying = true;
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
    [self takePicture];
    
}

- (IBAction)attachmentButtonPushed:(id)sender {
}

- (IBAction)helpButtonPushed:(id)sender {
    
    //[self performSegueWithIdentifier:@"helpTextPopover" sender:sender];
}

- (IBAction)notesButtonPushed:(id)sender {
    
    keyboardShouldMove = false;
    //[self performSegueWithIdentifier:@"notesPopover" sender:sender];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"helpTextPopover"]) {
        
        // Get destination view
        helpTextViewController * destVC = [segue destinationViewController];
        
        // Pass the information to your destination view
        [destVC setText:self.question.helpText];
    }
    
    if ([[segue identifier] isEqualToString:@"notesPopover"]) {
        
        // Get destination view
        NotesViewController * destVC = [segue destinationViewController];
        
        // Pass the information to your destination view
        [destVC setText:self.question.notes];
    }
    
//    if ([[segue identifier] isEqualToString:@"verifyPopOver"]) {
//        
//        // Get destination view
//        //VerifyPopOverViewController * verifyPop = [segue destinationViewController];
//        VerifyPopOverViewController *verifyPop = [segue destinationViewController];
//        
//        // Pass the information to destination VC
//        verifyPop.theAnswersVC = self;
//    
//        self.verifyPopOver.delegate = self;
//        self.verifyPopOver= [[UIPopoverController alloc] initWithContentViewController:verifyPop];
//    }
}

#pragma mark - Image picker delegate methdos

- (void)takePicture {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
#if TARGET_IPHONE_SIMULATOR
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    [self presentModalViewController:imagePickerController animated:YES];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Resize the image from the camera if we need to
    //	UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) interpolationQuality:kCGInterpolationHigh];
    
    // Crop the image to a square if we wanted.
    // UIImage *croppedImage = [scaledImage croppedImage:CGRectMake((scaledImage.size.width -photo.frame.size.width)/2, (scaledImage.size.height -photo.frame.size.height)/2, photo.frame.size.width, photo.frame.size.height)];
    // Show the photo on the screen

    
   // self.view.backgroundColor = [UIColor colorWithPatternImage: image];
    //TODO: save image to imagelocationArray / dropbox
    self.cameraImage = image;
    
    [picker dismissModalViewControllerAnimated:NO];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:NO];
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
@end
