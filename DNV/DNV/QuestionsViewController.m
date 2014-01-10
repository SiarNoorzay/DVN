//
//  QuestionsViewController.m
//  DNV
//
//  Created by USI on 1/9/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "QuestionsViewController.h"
#import "Audit.h"
#import "Elements.h"
#import "SubElements.h"
#import "AnswersViewController.h"


@interface QuestionsViewController ()

@end

@implementation QuestionsViewController

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
    
    if (self.questionArray == nil)
    {
        NSLog(@"Getting data from file for now");
        //doing this for now
    
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleAudit" ofType:@"json"]];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSDictionary *auditDict = [dict objectForKey:@"Audit"];
        Audit *aud = [[Audit alloc]initWithAudit:auditDict];
        
        Elements *ele = [[Elements alloc]initWithElement:aud.Elements[0]];
        SubElements *sub = [[SubElements alloc]initWithSubElement:ele.Subelements[0]];
        
        self.questionArray = sub.Questions;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.questionArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"QuestionCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Questions *question = [[Questions alloc]initWithQuestion:[self.questionArray objectAtIndex:indexPath.row]];
    
    cell.textLabel.text = question.questionText;
    
    //    cell.imageView.image = [UIImage imageNamed:@"check-mark-button.png"];
    
    return cell;
}

#pragma mark Segue Preparation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = self.questionsTableView.indexPathForSelectedRow;
    
    NSLog(@"Selected %@,",[self.questionArray objectAtIndex:indexPath.row]);
    
    AnswersViewController *vc = [segue destinationViewController];
    Questions *question = [[Questions alloc]initWithQuestion:[self.questionArray objectAtIndex:indexPath.row]];
    

    
    [vc setQuestion:question];
    [vc setQuestionArray:self.questionArray];
    [vc setCurrentPosition:indexPath.row];
    
    NSLog(@"Sending question: %@ to answers VC", question.questionText);
    
    
}


@end
