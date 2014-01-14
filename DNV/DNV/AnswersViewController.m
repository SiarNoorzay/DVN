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


@interface AnswersViewController ()

@end

float pointTotal = 0.0;
BOOL answered = false; //used for submit button logic
BOOL keyboardShouldMove = false;


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
    else{
        [self refreshAnswerView];
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

    
    [self.thumbsDownButton setImage:[UIImage imageNamed:@"thumbs-down.jpg"] forState:UIControlStateSelected];
    [self.thumbsDownButton setImage:[UIImage imageNamed:@"thumbs-down-button-Gray.jpg"] forState:UIControlStateNormal];
    
    [self.thumbsUpButton setImage:[UIImage imageNamed:@"thumbs-up.jpg"] forState:UIControlStateSelected];
    [self.thumbsUpButton setImage:[UIImage imageNamed:@"thumbs-up-buttonGray.jpg"] forState:UIControlStateNormal];

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
    self.picker.hidden = true;
    
    [self.firstButton setEnabled:true];
    [self.lastButton setEnabled:true];
    [self.nextButton setEnabled:true];
    [self.previousButton setEnabled:true];
    
    pointTotal = 0;
    self.pointsLabel.text = @"0";
    answered = false;
    self.percentSlider.value = 50;
    self.percentSliderTextField.text = @"";
    
    
    
}
-(void) refreshAnswerView
{
    
    self.question = [[Questions alloc]initWithQuestion:[self.questionArray objectAtIndex:self.currentPosition]];
    self.questionNumberTextField.text = [NSString stringWithFormat:@"%i",(self.currentPosition +1)];
    
    [self hideAnswerViews];
    NSLog(@"Question Type: %i",self.question.questionType);
    
    switch (self.question.questionType) {
        case 0: //bool
            self.answersTableView.hidden = false;
            self.answersTableView.allowsMultipleSelection = false;
            self.tableCell.hidden = false;
            break;
        case 1: //multiple choice
            self.answersTableView.hidden = false;
            self.answersTableView.allowsMultipleSelection = false;
            self.tableCell.hidden = false;
            break;
        case 2: //percentage
            self.percentSlider.hidden = false;
            self.percentSliderTextField.hidden = false;
            break;
        case 3: //partial
            self.answersTableView.hidden = false;
            self.answersTableView.allowsMultipleSelection = true;
            self.tableCell.hidden = false;
            break;
        case 4: //professional Judgement
            self.picker.hidden = false;
            break;
        case 5: //layered
            //TODO: Implement Layered questions
            NSLog(@"LAYERED QUESTIONS NOT YET IMPLEMENTED");
            break;
        default:
            NSLog(@"Should never get here");
            break;
    }//switch
    
    self.questionText.text = self.question.questionText;
    self.ansArray =  self.question.Answers;
    [self.answersTableView reloadData];
    
    self.questionNumLabel.text = [NSString stringWithFormat:@"%i.%i.%i", self.elementNumber +1,self.subElementNum +1 , self.currentPosition+1];
    
    
    if (self.currentPosition == [self.questionArray count]-1) {
       
        [self.lastButton setEnabled:false];
        [self.nextButton setEnabled:false];
    }
    if (self.currentPosition == 0) {
        
        [self.firstButton setEnabled:false];
        [self.previousButton setEnabled:false];
    }
    [self.thumbsUpButton setSelected:self.question.isThumbsUp];
    [self.thumbsDownButton setSelected:self.question.isThumbsDown];
    [self.naButton setSelected:!self.question.isApplicable];
    [self.verifyButton setSelected:self.question.needsVerifying];
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Delegate Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ansArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Answers *ans = [self.ansArray objectAtIndex:indexPath.row];
    
    pointTotal -= ans.pointsPossibleOrMultiplier;
    
    self.pointsLabel.text =[NSString stringWithFormat:@"%.2f",pointTotal];
    [ans setIsSelected:false];
    
}

#pragma mark - Picker View Delegate Methods

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   return self.question.pointsPossible;
}

#pragma mark  UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%i", row];
    
}



//If the user chooses from the pickerview, it calls this function;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Chosen item: %i", row);
    
    pointTotal = row;
    self.pointsLabel.text = [NSString stringWithFormat:@"%.2f",pointTotal];
    
    Answers *ans = [self.ansArray objectAtIndex:0];
    
    [ans setIsSelected:true];
    
    [ans setAnswerText:[NSString stringWithFormat:@"%.2f",pointTotal]];
    
    answered = true;
}



#pragma mark IBactions

- (IBAction)submitButton:(id)sender {
    //TODO: actually save stuff

    if (!answered) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"No answer" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
        
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
    self.percentSliderTextField.text = [NSString stringWithFormat:@"%.2f %%", self.percentSlider.value];
    self.pointsLabel.text = [NSString stringWithFormat:@"%.2f", (self.percentSlider.value * self.question.pointsPossible/100)];
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
    
    //check if out of bounds
    NSNumber *tempInt = [NSNumber numberWithInt:[self.questionNumberTextField.text intValue]];
    
    if (tempInt==nil || tempInt.intValue < 1 || tempInt.intValue > [self.questionArray count]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Out of range" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.currentPosition = tempInt.intValue - 1;
    [self refreshAnswerView];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
    return YES;
}



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
    
}
- (IBAction)verifyButtonPushed:(id)sender {
    self.question.needsVerifying = !self.question.needsVerifying;
    [self.verifyButton setSelected: !self.verifyButton.selected];
}

- (IBAction)percentTextChanged:(id)sender {
    
    float value = [self.percentSliderTextField.text floatValue];
    if (value < 0) value = 0;
    if (value > 100) value = 100;
    self.percentSlider.value = value;
    self.percentSliderTextField.text = [NSString stringWithFormat:@"%.2f", value];
    if ([self.percentSliderTextField canResignFirstResponder]) [self.percentSliderTextField resignFirstResponder];
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

- (IBAction)speechButtonPushed:(id)sender {
    keyboardShouldMove = false;
    [self performSegueWithIdentifier:@"notesPopover" sender:sender];

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



@end
