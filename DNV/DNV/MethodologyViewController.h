//
//  MethodologyViewController.h
//  DNV
//
//  Created by USI on 2/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Audit.h"

@interface MethodologyViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *methodPDFView;
@property (strong,nonatomic) Audit *audit;

@property (strong, nonatomic) IBOutlet UITextView *methodSummary;

@end
