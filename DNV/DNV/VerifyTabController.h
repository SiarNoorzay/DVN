//
//  VerifyTabController.h
//  DNV
//
//  Created by Jaime Martinez on 2/3/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Questions.h"

@interface VerifyTabController : UITabBarController

@property (assign) int currentSpot;
@property (nonatomic, strong) NSArray *listOfVerifyQuestions;
@property (nonatomic, strong) Questions *theQuestion;

@property (weak, nonatomic) IBOutlet UIButton *btnEditQuestion;

- (IBAction)btnEditQuestion:(id)sender;

@end
