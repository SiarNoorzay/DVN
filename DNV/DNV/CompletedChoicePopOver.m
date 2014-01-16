//
//  CompletedChoicePopOver.m
//  DNV
//
//  Created by USI on 1/15/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "CompletedChoicePopOver.h"

@interface CompletedChoicePopOver ()

@end

@implementation CompletedChoicePopOver

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)completedChoiceMade:(UIButton *)sender {

    [self.completedAuditVC.completedPopOver dismissPopoverAnimated:YES];
    self.completedAuditVC.completedChoice = sender.tag;
    [self.completedAuditVC goToCompletedChoice];
}

@end
