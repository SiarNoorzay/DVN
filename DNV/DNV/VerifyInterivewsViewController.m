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

@synthesize arrInterviewRows;

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
    
    arrInterviewRows = [NSMutableArray new];
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
    return [arrInterviewRows count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"verifyCell";
    
    verificationCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[verificationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    observationObject *aRow = [arrInterviewRows objectAtIndex:indexPath.row];
    
    cell.txtDescription.text = aRow.strDescription;
    cell.lblConfirmed.text = [NSString stringWithFormat:@"%d", aRow.iConfirmed];
    cell.lblNotConfirmed.text = [NSString stringWithFormat:@"%d", aRow.iNotConfrimed];
    cell.lblPercent.text = [NSString stringWithFormat:@"%f", aRow.fPercentage];
    cell.theObject = aRow;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [arrInterviewRows removeObjectAtIndex:indexPath.row];
    [self.tblInterview reloadData];
}
#pragma End TableView Methods

- (IBAction)btnAddRow:(id)sender {
    observationObject *oObj = [observationObject new];
    oObj.strDescription = @"Enter a description";
    oObj.iConfirmed = 0;
    oObj.iNotConfrimed = 0;
    oObj.fPercentage = 0.00;
    
    [arrInterviewRows addObject:oObj];
    [self.tblInterview reloadData];
}
@end
