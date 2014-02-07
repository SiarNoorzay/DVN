//
//  VerifyPhysicalViewController.m
//  DNV
//
//  Created by Jaime Martinez on 2/3/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "VerifyPhysicalViewController.h"
#import "verificationCell.h"
#import "VerifyTabController.h"

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
    
    self.dnvDB = [DNVDatabaseManagerClass getSharedInstance];
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
    
    Observations *aRow = [arrPhysicalRows objectAtIndex:indexPath.row];
    
    cell.txtDescription.text = aRow.description;
    cell.lblConfirmed.text = [NSString stringWithFormat:@"%d", aRow.confirmedCount];
    cell.lblNotConfirmed.text = [NSString stringWithFormat:@"%d", aRow.notConfirmedCount];
    cell.lblPercent.text = [NSString stringWithFormat:@"%f", aRow.percentComplete];
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
    [arrPhysicalRows removeObjectAtIndex:indexPath.row];
    [self.tblPhysical reloadData];
}

#pragma End TableView Methods

- (IBAction)btnAddRowToTable:(id)sender
{
    Observations *oObj = [Observations new];
    oObj.description = @"Enter a description";
    oObj.confirmedCount = 0;
    oObj.notConfirmedCount = 0;
    oObj.percentComplete = 0.00;
    
    VerifyTabController *myTabBar = (VerifyTabController*)self.tabBarController;
    [self.dnvDB saveObservationVerify:oObj ofType:0 forQuestion:myTabBar.theQuestion.questionID];
    
    [arrPhysicalRows addObject:oObj];
    [self.tblPhysical reloadData];
}

@end
