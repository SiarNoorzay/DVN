//
//  WIPChoicePopOver.h
//  DNV
//
//  Created by USI on 1/9/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIPAuditFilesViewController.h"

@interface WIPChoicePopOver : UIViewController

@property (weak, nonatomic) WIPAuditFilesViewController * WIPAuditFilesVC;

@property (nonatomic) BOOL dropBoxSelected;


- (IBAction)wipChoiceMade:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *exportToDBoxButton;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;


@end
