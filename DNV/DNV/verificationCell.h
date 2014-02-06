//
//  verificationCell.h
//  DNV
//
//  Created by Jaime Martinez on 2/3/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "observationObject.h"

@interface verificationCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblPercent;
@property (weak, nonatomic) IBOutlet UILabel *lblNotConfirmed;
@property (weak, nonatomic) IBOutlet UILabel *lblConfirmed;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

- (IBAction)stpConfirmed:(id)sender;
- (IBAction)stpNotConfirmed:(id)sender;
@property (weak, nonatomic) IBOutlet UIStepper *stpConfirmed;
@property (weak, nonatomic) IBOutlet UIStepper *stpNotConfirmed;

@property (assign) int iConfirm;
@property (assign) int iNotConfirm;

@property (nonatomic, strong) observationObject *theObject;

@end
