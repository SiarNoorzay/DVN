//
//  ConclusionViewController.h
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Audit.h"

@interface ConclusionViewController : UIViewController<UITextViewDelegate>
@property(strong,nonatomic) Audit *audit;


@property (strong, nonatomic) IBOutlet UITextField *percent;

@property (strong, nonatomic) IBOutlet UITextView *conclusionTextView;
@property (strong, nonatomic) IBOutlet UILabel *overPercentLabel;

@property (strong, nonatomic) IBOutlet UIView *conclusionPFDView;

@end
