//
//  ExecutiveSummaryViewController.h
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Audit.h"
#import "DNVDatabaseManagerClass.h"



@interface ExecutiveSummaryViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) Audit *audit;
@property (strong, nonatomic) DNVDatabaseManagerClass * dnvDBManager;

@property (strong, nonatomic) IBOutlet UIView *executiveSumPDFView;

@property (strong, nonatomic) IBOutlet UITextView *executiveSummary;
@property (strong, nonatomic) IBOutlet UILabel *auditCountLabel;
@property (strong, nonatomic) IBOutlet UITextView *elementList;

@end
