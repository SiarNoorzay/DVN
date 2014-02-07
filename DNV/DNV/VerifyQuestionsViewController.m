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
{
    Questions *selectedQuestion;
}
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
    
    
    Questions *theQuestion = [self.verifyQuestions objectAtIndex:indexPath.row];
    
    cell.textLabel.text = theQuestion.questionText;
    cell.textLabel.font = [UIFont systemFontOfSize:25.0];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedQuestion = [self.verifyQuestions objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"VerifyQuestionsTabBar" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:@"VerifyQuestionsTabBar"])
    {
        // Get destination tabbar
        VerifyTabController * destVC = [segue destinationViewController];
        
        // Pass the information to your destination view
        destVC.theQuestion = selectedQuestion;
    }
}

@end
