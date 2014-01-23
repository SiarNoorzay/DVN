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
    NSLog(@"Questions: %@",self.question.questionText);
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
    
    [self.switchy setOn: YES animated: YES];
    
    [self.switchy setDidChangeHandler:^(BOOL isOn) {
        NSLog(@"Switchy changed to %d", isOn);
        answered = true;
        Answers *leftAns = self.ansArray[1];
        Answers *rightAns = self.ansArray[0];
        
        
        if (isOn) {
            rightAns.isSelected = true;
            leftAns.isSelected = false;
            pointTotal = rightAns.pointsPossibleOrMultiplier;
            self.pointsLabel.text = [NSString stringWithFormat:@"%.2f",pointTotal];
        }
        else{
            leftAns.isSelected = true;
            rightAns.isSelected = true;
            pointTotal = leftAns.pointsPossibleOrMultiplier;
            self.pointsLabel.text = [NSString stringWithFormat:@"%.2f",pointTotal];

        }

        if (islayeredQuestion)
        {
            if (pointTotal >= self.question.pointsNeededForLayered)
            {
                [self.subQuesionsTableView setAllowsSelection:true];
            }
            else
            {
                [self.subQuesionsTableView setAllowsSelection:false];
                [self.subQuesionsTableView deselectRowAtIndexPath:[self.subQuesionsTableView indexPathForSelectedRow] animated:YES];
                
            }
            
        }
        
    }];
    }
    if ([self.question.layeredQuesions count] >=1)
    {
        islayeredQuestion = true;
        mainSubQuestion = self.question;
        mainQuestionPosition = self.currentPosition;
        NSLog(@"%i.%i.%i   %@", self.elementNumber +1,self.subElementNum +1 , self.currentPosition+1, mainSubQuestion.questionText);
        
        [self.mainLayeredQuesionButton setTitle:[NSString stringWithFormat:@"%i.%i.%i   %@", self.elementNumber +1,self.subElementNum +1 , self.currentPosition+1, mainSubQuestion.questionText] forState:UIControlStateNormal]  ;
    }
    else islayeredQuestion = false;
    
    
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
    
    
    [self.firstButton setEnabled:true];
    [self.lastButton setEnabled:true];
    [self.nextButton setEnabled:true];
    [self.previousButton setEnabled:true];
    
    pointTotal = 0;
    self.pointsLabel.text = @"0";
    answered = false;
    self.percentSlider.value = 50;
    self.percentSliderTextField.text = @"";
    
    if (useSlider){
        self.leftSliderLabel.hidden = true;
        self.rightSliderLabel.hidden = true;
        self.switchy.hidden = true;
    }
    
    
    
}
-(void) refreshAnswerView
{
    isSublayeredQuestion = (islayeredQuestion && self.currentPosition <0);
    
    if (isSublayeredQuestion) {
        //we get here when a subquestion was selected

        self.currentPosition++;
        self.currentPosition *= -1;
        self.question = [mainSubQuestion.layeredQuesions objectAtIndex:self.currentPosition];
        self.questionNumberTextField.text = [NSString stringWithFormat:@"%i",(self.currentPosition +1)];
        
    }
    else{
        self.question = [self.questionArray objectAtIndex:self.currentPosition];
        self.questionNumberTextField.text = [NSString stringWithFormat:@"%i",(self.currentPosition +1)];
    }
    
    
    self.ansArray =  self.question.Answers;

    [self hideAnswerViews];
    NSLog(@"Question Type: %i",self.question.questionType);
    
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
            }
            else
            {
                self.answersTableView.hidden = false;
                self.answersTableView.allowsMultipleSelection = false;
                self.tableCell.hidden = false;
            }
           
            break;
        case 1: //multiple choice
            self.answersTableView.hidden = false;
            self.answersTableView.allowsMultipleSelection = false;
            self.tableCell.hidden = false;
            break;
        case 2: //percentage
            self.percentSlider.hidden = false;
            self.percentSliderTextField.hidden = false;
            self.percentSlider.maximumValue = 100.0;
            self.percentSlider.minimumValue = 0;
            break;
        case 3: //partial
            self.answersTableView.hidden = false;
            self.answersTableView.allowsMultipleSelection = true;
            self.tableCell.hidden = false;
            break;
        case 4: //professional Judgement
            self.percentSlider.hidden = false;
            self.percentSliderTextField.hidden = false;
            self.percentSlider.maximumValue = self.question.pointsPossible;
            self.percentSlider.value = self.percentSlider.maximumValue /2;
            
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
    
    if (islayeredQuestion){// && [self.question.layeredQuesions count] >0) {
        self.layeredQuestionsView.hidden = false;
        if (pointTotal >= self.question.pointsNeededForLayered) {
            [self.subQuesionsTableView setAllowsSelection:YES];
        }
        else {[self.subQuesionsTableView setAllowsSelection:NO];}
        
        
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
    


        static NSString *simpleTableIdentifier = @"subQuestionCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        Questions *subQuest = [self.question.layeredQuesions objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:24];
        cell.textLabel.text =[NSString stringWithFormat: @"\t\t%i.%i.%i.%i\t%@",self.elementNumber +1,self.subElementNum +1 , self.currentPosition+1,indexPath.row +1, subQuest.questionText];
    
        return cell;
        
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.answersTableView) {
        
        return [self.ansArray count];
    }
    
    if (tableView == self.subQuesionsTableView) {

        return [self.question.layeredQuesions count];
        
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
        
        pointTotal += ans.pointsPossibleOrMultiplier;
        
        self.pointsLabel.text =[NSString stringWithFormat:@"%.2f",pointTotal];
        
        [ans setIsSelected:true];
        answered = true;//used for submit button logic
    }
    
    else if ( tableView == self.subQuesionsTableView)
    {
        self.question = [mainSubQuestion.layeredQuesions objectAtIndex:indexPath.row];
        self.currentPosition = (indexPath.row +1) * -1;

        [self refreshAnswerView];
        
    }

    
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.answersTableView) {
        Answers *ans = [self.ansArray objectAtIndex:indexPath.row];
        
        pointTotal -= ans.pointsPossibleOrMultiplier;
        
        self.pointsLabel.text =[NSString stringWithFormat:@"%.2f",pointTotal];
        [ans setIsSelected:false];
    }
    
    
}




#pragma mark IBactions

- (IBAction)submitButton:(id)sender {

    if (!answered) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"No answer" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    self.question.isCompleted = true;
    self.question.pointsAwarded = pointTotal;
    //TODO: actually save stuff

    
    if (islayeredQuestion && (pointTotal >= self.question.pointsNeededForLayered )&& !(isSublayeredQuestion)) {
        //main question answered to show subs so go to first subquestion
       
        [self.subQuesionsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        self.question = [mainSubQuestion.layeredQuesions objectAtIndex:0];
        self.currentPosition = -1;
        [self refreshAnswerView];
        return;
    }
    if (islayeredQuestion && !(isSublayeredQuestion)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Skipped %d questions", [mainSubQuestion.layeredQuesions count]] message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
        if (layeredPosition == (-1* [mainSubQuestion.layeredQuesions count])) {
            //were at the last subquestion so pop 2 VCs
             [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
            return;
        }
        else //not last subquestion so go to next one
        {
            NSLog(@"%d",layeredPosition);
            layeredPosition--;
            
            [self.subQuesionsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:(layeredPosition +1)*-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            self.question = [mainSubQuestion.layeredQuesions objectAtIndex:(layeredPosition +1 ) *-1];
            self.currentPosition = layeredPosition;
            [self refreshAnswerView];
            return;
        }
        
        
    }
    
    if (self.currentPosition == ([self.questionArray count]-1))
    {
        //pop 2 view controllers
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
    }
    else{
        self.currentPosition++;
        [self refreshAnswerView];
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
    self.question.needsVerifying = !self.question.needsVerifying;
    [self.verifyButton setSelected: !self.verifyButton.selected];
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
    
    [self.calcPopOver presentPopoverFromRect:self.calculatorButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
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
@end
