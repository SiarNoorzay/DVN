//
//  TableofContentsViewController.h
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Audit.h"


@interface TableofContentsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *tableOfConPDFView;

@property (strong, nonatomic) Audit *audit;

@end
