//
//  VerifyRecordsViewController.m
//  DNV
//
//  Created by Jaime Martinez on 2/3/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "VerifyRecordsViewController.h"
#import "verifyRecordsCell.h"
#import "recordsObject.h"

@interface VerifyRecordsViewController ()

@end

@implementation VerifyRecordsViewController

@synthesize arrRecordRows;

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
    
    arrRecordRows = [NSMutableArray new];
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
    return [arrRecordRows count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"verifyRecords";
    
    verifyRecordsCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[verifyRecordsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    recordsObject *aRow = [arrRecordRows objectAtIndex:indexPath.row];
    
    cell.txtDescription.text = aRow.strDescription;
    
    if( aRow.bConfirmed && cell.btnCheckBox.tag != 1)
        [cell btnCheckBox:cell.btnCheckBox];
    else if( !aRow.bConfirmed && cell.btnCheckBox.tag != 0)
        [cell btnCheckBox:cell.btnCheckBox];
    
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
    [arrRecordRows removeObjectAtIndex:indexPath.row];
    [self.tblRecords reloadData];
}
#pragma End TableView Methods


- (IBAction)btnAddToTable:(id)sender {
    recordsObject *rObj = [recordsObject new];
    rObj.strDescription = @"Enter a description";
    rObj.bConfirmed = false;
    
    [arrRecordRows addObject:rObj];
    [self.tblRecords reloadData];
}
@end
