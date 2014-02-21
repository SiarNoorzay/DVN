//
//  TitleViewController.h
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Audit.h"
#import "ReportDocViewController.h"
#import "DNVDatabaseManagerClass.h"

@interface TitleViewController : UIViewController

@property (strong, atomic) Audit *audit;

@property (strong, nonatomic) DNVDatabaseManagerClass * dnvDBManager;

@property (strong, nonatomic) IBOutlet UITextField *clientName;
@property (strong, nonatomic) IBOutlet UITextField *date;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)datePickerValueChanged:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *titlePdfView;

@end
