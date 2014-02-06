//
//  QuestionCell.h
//  DNV
//
//  Created by USI on 1/15/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *doneImage;
@property (strong, nonatomic) IBOutlet UILabel *points;
@property (strong, nonatomic) IBOutlet UILabel *questionText;

@end
