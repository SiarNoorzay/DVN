//
//  KeySuggesstionCell.h
//  DNV
//
//  Created by USI on 1/24/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeySuggesstionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *notesTextLabel;

@end
