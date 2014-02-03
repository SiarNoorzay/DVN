//
//  VerifyQuestionsViewController.m
//  DNV
//
//  Created by USI on 1/14/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "VerifyQuestionsViewController.h"
#import "VerifyTabController.h"

@interface VerifyQuestionsViewController ()

@property NSArray * verifyQuestions;

@end

@implementation VerifyQuestionsViewController

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
    
    self.verifyQuestions = [[NSArray alloc]initWithObjects:@"Is the freezer temperature at a constant 30 degrees?",@"Has the water filter been changed recently?", @"Are all meats being refrigerated properly for consumption?",@"What is the maximum hot water temperature for the kitchen faucets?", nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.verifyQuestions count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"VerifyQuestionCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    
    cell.textLabel.text = self.verifyQuestions[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:25.0];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"VerifyQuestionsTabBar" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //to set which of the 3 tabs are selectable
    NSIndexPath *indexPath = self.VerifyQuestionsTable.indexPathForSelectedRow;
    VerifyTabController * verifyTabCont = [segue destinationViewController];
}



@end
