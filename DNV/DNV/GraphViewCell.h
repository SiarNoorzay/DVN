//
//  GraphViewCell.h
//  DNV
//
//  Created by USI on 2/11/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet GraphView *graphViewImage;
@property (strong, nonatomic) IBOutlet UILabel *elementSubName;

@end
