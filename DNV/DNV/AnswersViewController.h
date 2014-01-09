//
//  AnswersViewController.h
//  DNV
//
//  Created by USI on 1/9/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Questions.h"
#import "Answers.h"

@interface AnswersViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) Questions *question;

@property (nonatomic, strong) NSArray *ansArray;

@property (strong, nonatomic) IBOutlet UILabel *percentSliderLabel;
- (IBAction)submitButton:(id)sender;
- (IBAction)sliderChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *answersTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *tableCell;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UISlider *percentSlider;

@property (strong, nonatomic) IBOutlet UILabel *questionText;
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;

@end
