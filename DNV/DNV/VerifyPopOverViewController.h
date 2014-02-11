//
//  VerifyPopOverViewController.h
//  DNV
//
//  Created by Jaime Martinez on 2/4/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswersViewController.h"

@interface VerifyPopOverViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnPhysical;
@property (weak, nonatomic) IBOutlet UIButton *btnInterviews;
@property (weak, nonatomic) IBOutlet UIButton *btnRecords;

- (IBAction)btnToggler:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnGoToVerifyTabBar;

- (IBAction)btnGoToVerifyTabBar:(id)sender;

@property (strong, nonatomic) AnswersViewController *theAnswersVC;

@end
