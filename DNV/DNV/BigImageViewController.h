//
//  BigImageViewController.h
//  DNV
//
//  Created by USI on 2/11/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Questions.h"

@interface BigImageViewController : UIViewController
- (IBAction)backButtonsPushed:(id)sender;
- (IBAction)deleteButtonPushed:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *bigImageView;


@property (strong,nonatomic) Questions *question;

@property NSIndexPath *indexPath;


@end
