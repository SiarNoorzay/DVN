//
//  CalculatorViewController.h
//  DNV
//
//  Created by USI on 1/17/14.
//  Copyright (c) 2014 USI. All rights reserved.
//
//  Modified code from iPhoneCalculator by oscardelben



#import <UIKit/UIKit.h>
#import "AnswersViewController.h"



// We store the various buttons in a custom enumerator

typedef enum {
    kButtonMC, // 0
    kButtonMPlus, // 1
    kButtonMMinus, // 2
    kButtonMR, // etc
    
    kButtonAC,
    kButtonChangeSign,
    kButtonDivide,
    kButtonMultiply,
    
    kButtonSeven,
    kButtonEight,
    kButtonNine,
    kButtonSubtract,
    
    kButtonFour,
    kButtonFive,
    kButtonSix,
    kButtonAdd,
    
    kButtonOne,
    kButtonTwo,
    kButtonThree,
    
    kButtonZero,
    kButtonDot,
    kButtonEqual
} kButton;

@interface CalculatorViewController : UIViewController
{
    NSNumber *leftOperator;
    kButton operation;
    BOOL deleteInput;
    double memory;
}
@property (weak, nonatomic) AnswersViewController *ansVC;

@property (nonatomic, retain) UILabel *resultLabel;
@property (nonatomic, retain) NSMutableString *resultText;




- (IBAction)calcSubmitPushed:(id)sender;

- (void)buttonPressed:(id)sender;

@end