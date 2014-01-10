//
//  AnswersViewController.m
//  DNV
//
//  Created by USI on 1/9/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "AnswersViewController.h"
#import "ElementSubElementViewController.h"

@interface AnswersViewController ()

@end

float pointTotal = 0.0;
BOOL answered = false;



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
}


-(void)hideAnswerViews
{
    self.tableCell.hidden = true;
    self.answersTableView.hidden = true;
    self.percentSliderLabel.hidden = true;
    self.percentSlider.hidden = true;
    self.picker.hidden = true;
    
    [self.firstButton setEnabled:true];
    [self.lastButton setEnabled:true];
    
    pointTotal = 0;
    self.pointsLabel.text = @"0";
    answered = false;
    
}
-(void) refreshAnswerView
{
    self.question = [[Questions alloc]initWithQuestion:[self.questionArray objectAtIndex:self.currentPosition]];
    
    
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
            self.percentSliderLabel.hidden = false;
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
    }
    if (self.currentPosition == 0) {
        
        [self.firstButton setEnabled:false];
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
    static NSString *simpleTableIdentifier = @"AnswerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Answers *ans = [self.ansArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = ans.answerText;
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
    
    answered = true;
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Answers *ans = [self.ansArray objectAtIndex:indexPath.row];
    
    pointTotal -= ans.pointsPossibleOrMultiplier;
    
    self.pointsLabel.text =[NSString stringWithFormat:@"%.2f",pointTotal];
}

#pragma mark Picker View Delegate Methods

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

#pragma mark - UIPickerView Delegate
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
    self.percentSliderLabel.text = [NSString stringWithFormat:@"%.2f %%", self.percentSlider.value];
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
@end
