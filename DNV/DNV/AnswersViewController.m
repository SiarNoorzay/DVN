//
//  AnswersViewController.m
//  DNV
//
//  Created by USI on 1/9/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "AnswersViewController.h"

@interface AnswersViewController ()

@end

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
    
    if (self.question == nil)
    {
        NSLog(@"SHOULD NOT GET HERE, (recieved a nil question from previous VC)");
    }
    else{
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
                NSLog(@"LAYERED QUESTIONS NOT YET IMPLEMENTED");
                break;
            default:
                NSLog(@"Should never get here");
                break;
        }//switch
        
        self.questionText.text = self.question.questionText;
        self.ansArray = self.question.Answers;
        
        
    }
    
}
-(void)hideAnswerViews
{
    self.tableCell.hidden = true;
    self.answersTableView.hidden = true;
    self.percentSliderLabel.hidden = true;
    self.percentSlider.hidden = true;
    self.picker.hidden = true;
    
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
    self.pointsLabel.text = [NSString stringWithFormat:@"%.2f",ans.pointsPossibleOrMultiplier];
    
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
}

#pragma mark IBactions

- (IBAction)submitButton:(id)sender {
}

- (IBAction)sliderChanged:(id)sender {
    self.percentSliderLabel.text = [NSString stringWithFormat:@"%.2f %%", self.percentSlider.value];
    
    
}
@end
