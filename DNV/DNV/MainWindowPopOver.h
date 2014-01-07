//
//  MainWindowPopOver.h
//  DNV
//
//  Created by USI on 1/7/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainWindowPopOver : UIViewController

@property (nonatomic) int auditChoice;

@property (weak, nonatomic) UIPopoverController * popOverContent;

- (IBAction)newAuditBtn:(UIButton *)sender;
- (IBAction)wipAuditBtn:(UIButton *)sender;
- (IBAction)completedAuditBtn:(UIButton *)sender;

@end
