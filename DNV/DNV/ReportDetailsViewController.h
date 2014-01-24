//
//  ReportDetailsViewController.h
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Audit.h"

@interface ReportDetailsViewController : UIViewController
@property (strong, nonatomic) Audit *audit;


@property (strong, nonatomic) IBOutlet UITextField *clientRef;
@property (strong, nonatomic) IBOutlet UITextView *summary;
@property (strong, nonatomic) IBOutlet UITextField *preparedBy;
@property (strong, nonatomic) IBOutlet UITextField *approvedBy;

@property (strong, nonatomic) IBOutlet UITextField *dateOfIssue;
@property (strong, nonatomic) IBOutlet UITextField *projectNum;


@end
