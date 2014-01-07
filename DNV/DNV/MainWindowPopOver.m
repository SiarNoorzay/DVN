//
//  MainWindowPopOver.m
//  DNV
//
//  Created by USI on 1/7/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "MainWindowPopOver.h"

@interface MainWindowPopOver ()

@end

@implementation MainWindowPopOver

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
    self.auditChoice = 100;
    NSLog(@"Popover here");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newAuditBtn:(UIButton *)sender {
    
    self.auditChoice = 0;
    [self.popOverContent dismissPopoverAnimated:true];
}

- (IBAction)wipAuditBtn:(UIButton *)sender {
    
    self.auditChoice = 1;
    [self.popOverContent dismissPopoverAnimated:true];
}

- (IBAction)completedAuditBtn:(UIButton *)sender {
    
    self.auditChoice = 2;
    [self.popOverContent dismissPopoverAnimated:true];
}

@end
