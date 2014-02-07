//
//  VerifyInterivewsViewController.m
//  DNV
//
//  Created by Jaime Martinez on 2/3/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "VerifyInterivewsViewController.h"
#import "verificationCell.h"
#import "Observations.h"
#import "VerifyTabController.h"

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
    
    self.dnvDB = [DNVDatabaseManagerClass getSharedInstance];
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
    
    Observations *aRow = [arrInterviewRows objectAtIndex:indexPath.row];
    
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
    [arrInterviewRows removeObjectAtIndex:indexPath.row];
    [self.tblInterview reloadData];
}
#pragma End TableView Methods

- (IBAction)btnAddRow:(id)sender {
    Observations *oObj = [Observations new];
    oObj.description = @"Enter a description";
    oObj.confirmedCount = 0;
    oObj.notConfirmedCount = 0;
    oObj.percentComplete = 0.00;
    
    VerifyTabController *myTabBar = (VerifyTabController*)self.tabBarController;
    [self.dnvDB saveObservationVerify:oObj ofType:1 forQuestion:myTabBar.theQuestion.questionID];
    
    [arrInterviewRows addObject:oObj];
    [self.tblInterview reloadData];
}
@end
