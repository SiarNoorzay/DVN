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
{
    VerifyTabController *myTabBar;
}
@end

@implementation VerifyInterivewsViewController

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
    
    if ([myTabBar.theQuestion.InterviewObservations count] == 0)
    {
        [self btnAddRow:self];
    }
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
    return [myTabBar.theQuestion.InterviewObservations count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"verifyCell";
    
    verificationCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[verificationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Observations *aRow = [myTabBar.theQuestion.InterviewObservations objectAtIndex:indexPath.row];
    
    cell.txtDescription.text = aRow.description;
    cell.lblConfirmed.text = [NSString stringWithFormat:@"%d", aRow.confirmedCount];
    cell.lblNotConfirmed.text = [NSString stringWithFormat:@"%d", aRow.notConfirmedCount];
    cell.lblPercent.text = [NSString stringWithFormat:@"%.2f", aRow.percentComplete];
    cell.theObject = aRow;
    cell.dnvDB = self.dnvDB;
    
    
    cell.stpConfirmed.value = aRow.confirmedCount;
    cell.stpNotConfirmed.value = aRow.notConfirmedCount;
    
    [cell setPercent];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:myTabBar.theQuestion.InterviewObservations];
    
    [self.dnvDB deleteVerify:((Observations *)[temp objectAtIndex:indexPath.row]).observationID];

    [temp removeObjectAtIndex:indexPath.row];
    
    myTabBar.theQuestion.InterviewObservations = temp;
    
    [self.tblInterview reloadData];
}
#pragma End TableView Methods

- (IBAction)btnAddRow:(id)sender {
    Observations *oObj = [Observations new];
    oObj.description = @"Enter a description";
    oObj.confirmedCount = 0;
    oObj.notConfirmedCount = 0;
    oObj.percentComplete = 0.00;
    
    oObj.observationID = [self.dnvDB saveObservationVerify:oObj ofType:1 forQuestion:myTabBar.theQuestion.questionID];
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:myTabBar.theQuestion.InterviewObservations];
    [temp addObject:oObj];
    myTabBar.theQuestion.InterviewObservations = temp;
    
    
    [self.tblInterview reloadData];
}
@end
