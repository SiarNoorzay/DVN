//
//  GraphView.h
//  DNV
//
//  Created by USI on 1/22/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECGraph.h"

@interface GraphView : UIView<ECGraphDelegate>

@property (strong,nonatomic) NSArray * elementNames;
@property (strong,nonatomic) NSArray * elementPercent;



@end
