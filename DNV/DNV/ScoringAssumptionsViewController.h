//
//  ScoringAssumptionsViewController.h
//  DNV
//
//  Created by USI on 1/24/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Audit.h"

@interface ScoringAssumptionsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *scoreAssumpTextView;
@property (strong,nonatomic) Audit *audit;


@end