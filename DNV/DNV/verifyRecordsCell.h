//
//  verifyRecordsCell.h
//  DNV
//
//  Created by Jaime Martinez on 2/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "recordsObject.h"

@interface verifyRecordsCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;
- (IBAction)btnCheckBox:(id)sender;

@property (nonatomic, strong) recordsObject *theObject;

@property (nonatomic, strong) UIImageView *imgGreenCheck;
@end
