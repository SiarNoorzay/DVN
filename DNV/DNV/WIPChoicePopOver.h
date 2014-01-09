//
//  WIPChoicePopOver.h
//  DNV
//
//  Created by USI on 1/9/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListOfWIPViewController.h"

@interface WIPChoicePopOver : UIViewController

@property (weak, nonatomic) ListOfWIPViewController * listOfWIPVC;

- (IBAction)wipChoiceMade:(UIButton *)sender;


@end
