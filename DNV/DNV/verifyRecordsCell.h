//
//  verifyRecordsCell.h
//  DNV
//
//  Created by Jaime Martinez on 2/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Records.h"
#import "DNVDatabaseManagerClass.h"

@interface verifyRecordsCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;
- (IBAction)btnCheckBox:(id)sender;

@property (nonatomic, strong) Records *theObject;

@property (nonatomic, strong) UIImageView *imgGreenCheck;

@property(nonatomic, strong) DNVDatabaseManagerClass *dnvDB;

-(void)setGreenCheck: (BOOL)bToSet;

@end
