//
//  DrawingViewController.h
//  DNV
//
//  Created by USI on 1/17/14.
//  Copyright (c) 2014 USI. All rights reserved.
//
//  Modified code from DrawPad by Ray Wenderlich
//  http://www.raywenderlich.com/18840/how-to-make-a-simple-drawing-app-with-uikit


#import <UIKit/UIKit.h>

@interface DrawingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;


- (IBAction)saveButtonPushed:(id)sender;
- (IBAction)resetButtonPushed:(id)sender;
- (IBAction)cancelButtonPushed:(id)sender;

@end
