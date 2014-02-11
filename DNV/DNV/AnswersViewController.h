//
//  AnswersViewController.h
//  DNV
//
//  Created by USI on 1/9/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KLSwitch/KLSwitch.h>
#import "DNVDatabaseManagerClass.h"

#import "Questions.h"
#import "Answers.h"

#import "Audit.h"

@interface AnswersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPopoverControllerDelegate>


@property (assign) bool cameFromVerifyTabBar;

@property (nonatomic, strong) Questions *question;
@property (nonatomic) NSArray * questionArray;
@property (nonatomic) int currentPosition;

@property (nonatomic, strong) NSArray *ansArray;
@property (nonatomic) int elementNumber;
@property (nonatomic) int subElementNum;
@property (strong,nonatomic) UIPopoverController * helpPopOver;
@property (strong,nonatomic) UIImage *cameraImage;
@property (strong, nonatomic) Audit * audit;

@property (strong, nonatomic) DNVDatabaseManagerClass * dnvDBManager;

@property (strong, nonatomic) IBOutlet UIButton *calculatorButton;
@property (strong, nonatomic) IBOutlet KLSwitch *switchy;
@property (strong, nonatomic) IBOutlet UILabel *rightSliderLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftSliderLabel;


- (IBAction)submitButton:(id)sender;
- (IBAction)sliderChanged:(id)sender;
- (IBAction)lastButtonPushed:(id)sender;
- (IBAction)firstButtonPushed:(id)sender;
- (IBAction)nextButtonPushed:(id)sender;
- (IBAction)previousButtonPushed:(id)sender;
- (IBAction)textFieldEndedEditing:(id)sender;
- (IBAction)thumbsUpPushed:(id)sender;
- (IBAction)thumbsDownPushed:(id)sender;
- (IBAction)naButtonPushed:(id)sender;
- (IBAction)calculatorButtonPushed:(id)sender;
- (IBAction)cameraButtonPushed:(id)sender;
- (IBAction)attachmentButtonPushed:(id)sender;
- (IBAction)helpButtonPushed:(id)sender;
- (IBAction)notesButtonPushed:(id)sender;
- (IBAction)verifyButtonPushed:(id)sender;
- (IBAction)percentTextChanged:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *answersTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *tableCell;

@property (strong, nonatomic) IBOutlet UIView *layeredQuestionsView;

//layered question
@property (strong, nonatomic) IBOutlet UITableView *subQuesionsTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *subQuestionsCell;
@property (strong, nonatomic) IBOutlet UIButton *mainLayeredQuesionButton;
- (IBAction)mainLayeredPushed:(id)sender;
@property (strong,atomic) NSMutableArray *allSublayeredQuestions;

-(void)setEnabledFlagsAndReloadQuestions;



@property (strong, nonatomic) IBOutlet UIButton *firstButton;
@property (strong, nonatomic) IBOutlet UIButton *lastButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *previousButton;
@property (strong, nonatomic) IBOutlet UIButton *thumbsUpButton;
@property (strong, nonatomic) IBOutlet UIButton *thumbsDownButton;
@property (strong, nonatomic) IBOutlet UIButton *naButton;
@property (strong, nonatomic) IBOutlet UIButton *verifyButton;

@property (strong, nonatomic) IBOutlet UISlider *percentSlider;
@property (strong, nonatomic) IBOutlet UITextField *questionNumberTextField;

@property (strong, nonatomic) IBOutlet UILabel *questionText;
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) IBOutlet UILabel *questionNumLabel;
@property (strong, nonatomic) IBOutlet UITextField *percentSliderTextField;

@property (strong,nonatomic) UIPopoverController * calcPopOver;
@property (strong,nonatomic) UIPopoverController * verifyPopOver;

-(void)setNeedsVerifying: (int)vSelected;

@property (weak, nonatomic) IBOutlet UIView *viewDashboard;

@end
