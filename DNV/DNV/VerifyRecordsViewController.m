//
//  VerifyRecordsViewController.m
//  DNV
//
//  Created by Jaime Martinez on 2/3/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "VerifyRecordsViewController.h"
#import "verifyRecordsCell.h"
#import "Records.h"
#import "VerifyTabController.h"

@interface VerifyRecordsViewController ()
{
    VerifyTabController *myTabBar;
}
@end

@implementation VerifyRecordsViewController


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
    
    self.dnvDB = [DNVDatabaseManagerClass getSharedInstance];
    
    myTabBar = (VerifyTabController*)self.tabBarController;
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
    return [myTabBar.theQuestion.Records count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"verifyRecords";
    
    verifyRecordsCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[verifyRecordsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Records *aRow = [myTabBar.theQuestion.Records objectAtIndex:indexPath.row];
    
    cell.txtDescription.text = aRow.description;
    
    if( aRow.isConfirmed && cell.btnCheckBox.tag != 1)
        [cell btnCheckBox:cell.btnCheckBox];
    else if( !aRow.isConfirmed && cell.btnCheckBox.tag != 0)
        [cell btnCheckBox:cell.btnCheckBox];
    
    cell.theObject = aRow;
    cell.dnvDB = self.dnvDB;
    
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
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:myTabBar.theQuestion.Records];
    [temp removeObjectAtIndex:indexPath.row];
    myTabBar.theQuestion.Records = temp;
    
    [self.tblRecords reloadData];
}
#pragma End TableView Methods


- (IBAction)btnAddToTable:(id)sender {
    Records *rObj = [Records new];
    rObj.description = @"Enter a description";
    rObj.isConfirmed = false;
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:myTabBar.theQuestion.Records];
    [temp addObject:rObj];
     myTabBar.theQuestion.Records = temp;
    
    rObj.recordID = [self.dnvDB saveRecordVerify:rObj forQuestion:myTabBar.theQuestion.questionID];
    
    [self.tblRecords reloadData];
}
@end
