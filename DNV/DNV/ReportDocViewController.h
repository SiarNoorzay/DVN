//
//  ReportDocViewController.h
//  DNV
//
//  Created by USI on 1/22/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Audit.h"

@interface ReportDocViewController : UIViewController

@property (strong, nonatomic) Audit *audit;

@property (strong, nonatomic) IBOutlet UIScrollView *reportScrollView;

@end
