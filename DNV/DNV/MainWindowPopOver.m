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


}

-(void)viewWillAppear:(BOOL)animated{
    
    if (self.internetConnect)
        self.auditBtnNew.enabled = true;
    else
        self.auditBtnNew.enabled = false;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnChoiceMade:(UIButton *)sender
{
    [self.clientVC.clientPopOver dismissPopoverAnimated:YES];
    self.clientVC.auditType = sender.tag;
    [self.clientVC goToChoice];
}

@end
