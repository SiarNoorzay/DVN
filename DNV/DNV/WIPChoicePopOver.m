//
//  WIPChoicePopOver.m
//  DNV
//
//  Created by USI on 1/9/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "WIPChoicePopOver.h"

@interface WIPChoicePopOver ()

@end

@implementation WIPChoicePopOver

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
    if (self.dropBoxSelected) {
        self.exportToDBoxButton.enabled = false;
    }
    else self.exportToDBoxButton.enabled = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)wipChoiceMade:(UIButton *)sender {

    [self.WIPAuditFilesVC.wipPopOver dismissPopoverAnimated:YES];
    self.WIPAuditFilesVC.wipJSONChoice = sender.tag;
    [self.WIPAuditFilesVC goToWIPChoice];
}

- (IBAction)btnDeleteWip:(id)sender {
}
@end
