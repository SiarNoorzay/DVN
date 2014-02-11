//
//  ImagePopOverViewController.h
//  DNV
//
//  Created by USI on 2/10/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Questions.h"


@interface ImagePopOverViewController : UIViewController

@property (strong, nonatomic) Questions *question;

- (IBAction)takePicturePushed:(id)sender;
- (IBAction)choosePicPushed:(id)sender;
- (void)takePicture:(BOOL)useCamera;

@end
