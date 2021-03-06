//
//  MainWindowPopOver.h
//  DNV
//
//  Created by USI on 1/7/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientViewController.h"

@interface MainWindowPopOver : UIViewController

@property (nonatomic) BOOL internetConnect;

@property (weak, nonatomic) ClientViewController *clientVC;

@property (strong, nonatomic) IBOutlet UIButton *auditBtnNew;

- (IBAction)btnChoiceMade:(UIButton *)sender;

@end
