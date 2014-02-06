//
//  VerifyInterivewsViewController.m
//  DNV
//
//  Created by Jaime Martinez on 2/3/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "VerifyInterivewsViewController.h"
#import "verificationCell.h"
#import "observationObject.h"

@interface VerifyInterivewsViewController ()

@end

@implementation VerifyInterivewsViewController

@synthesize arrPhysicalRows;

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
    
    arrPhysicalRows = [NSMutableArray new];
    [arrPhysicalRows addObject:[observationObject new]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Begin TableView Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrPhysicalRows count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"verifyCell";
    
    verificationCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[verificationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}
#pragma End TableView Methods

@end
