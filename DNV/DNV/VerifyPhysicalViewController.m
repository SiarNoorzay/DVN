//
//  VerifyPhysicalViewController.m
//  DNV
//
//  Created by Jaime Martinez on 2/3/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "VerifyPhysicalViewController.h"
#import "verificationCell.h"
#import "observationObject.h"

@interface VerifyPhysicalViewController ()

@end

@implementation VerifyPhysicalViewController

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
    
    observationObject *aRow = [arrPhysicalRows objectAtIndex:indexPath.row];
    
    cell.txtDescription.text = aRow.strDescription;
    cell.lblConfirmed.text = [NSString stringWithFormat:@"%d", aRow.iConfirmed];
    cell.lblNotConfirmed.text = [NSString stringWithFormat:@"%d", aRow.iNotConfrimed];
    cell.lblPercent.text = [NSString stringWithFormat:@"%f", aRow.fPercentage];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0;
//}
#pragma End TableView Methods

- (IBAction)btnAddRowToTable:(id)sender
{
    observationObject *oObj = [observationObject new];
    oObj.strDescription = @"";
    oObj.iConfirmed = 0;
    oObj.iNotConfrimed = 0;
    oObj.fPercentage = 0.00;
    
    [arrPhysicalRows addObject:oObj];
    [self.tblPhysical reloadData];
}
@end
