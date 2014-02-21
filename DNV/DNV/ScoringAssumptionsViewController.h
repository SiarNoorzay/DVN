//
//  ScoringAssumptionsViewController.h
//  DNV
//
//  Created by USI on 1/24/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Audit.h"
#import "DNVDatabaseManagerClass.h"

@interface ScoringAssumptionsViewController : UIViewController<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *scoreAssumpTextView;
@property (strong,nonatomic) Audit *audit;
@property (strong, nonatomic) DNVDatabaseManagerClass * dnvDBManager;

@property (strong, nonatomic) IBOutlet UIView *scoringAsumPDFView;

@end
