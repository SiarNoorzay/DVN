//
//  ElementRatingsCell.h
//  DNV
//
//  Created by USI on 1/21/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElementRatingsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *elementName;

@property (strong, nonatomic) IBOutlet UILabel *required;

@property (strong, nonatomic) IBOutlet UILabel *pointsPossible;
@property (strong, nonatomic) IBOutlet UILabel *pointsAwarded;

@property (strong, nonatomic) IBOutlet UILabel *percentage;

@end
