//
//  CompletedChoicePopOver.h
//  DNV
//
//  Created by USI on 1/15/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListOfCompletedViewController.h"

@interface CompletedChoicePopOver : UIViewController

@property (weak, nonatomic) ListOfCompletedViewController * completedAuditVC;

- (IBAction)completedChoiceMade:(UIButton *)sender;


@end
