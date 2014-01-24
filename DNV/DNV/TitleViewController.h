//
//  TitleViewController.h
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Audit.h"

@interface TitleViewController : UIViewController<UIPageViewControllerDataSource>

@property (strong, atomic) Audit *audit;

@property (strong, nonatomic) IBOutlet UITextField *clientName;
@property (strong, nonatomic) IBOutlet UITextField *date;

@end
