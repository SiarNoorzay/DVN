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
        
        NSLog(@"Number: %i.%i",self.elementNumber,self.subEleNumber);
        
    
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleAudit" ofType:@"json"]];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSDictionary *auditDict = [dict objectForKey:@"Audit"];
        Audit *aud = [[Audit alloc]initWithAudit:auditDict];
        
        Elements *ele = aud.Elements[0];
        SubElements *sub = ele.Subelements[0];
        
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
    
    QuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[QuestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Questions *question = [self.questionArray objectAtIndex:indexPath.row];
    
    cell.questionText.text = question.questionText;
    if (question.isApplicable) {
        cell.points.text = [NSString stringWithFormat:@"%.2f / %.2f", question.pointsAwarded,question.pointsPossible];
    }
    else
    {
        cell.points.text = @" 0 / 0 ";
    }
    
    
    //cell.textLabel.font = [UIFont systemFontOfSize:25.0];
    
    if (question.isCompleted)
    {
      //  cell.imageView.image = [UIImage imageNamed:@"check-mark-button.png"];
        cell.doneImage.hidden = NO;
    }
    else{
       cell.doneImage.hidden = YES;
    }
    return cell;
}

#pragma mark Segue Preparation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = self.questionsTableView.indexPathForSelectedRow;
    
  //  NSLog(@"Selected %@,",[self.questionArray objectAtIndex:indexPath.row]);
    
    AnswersViewController *vc = [segue destinationViewController];
    Questions *question = [self.questionArray objectAtIndex:indexPath.row];
    

    [vc setElementNumber:self.elementNumber];
    [vc setSubElementNum:self.subEleNumber];
    
    [vc setQuestion:question];
    [vc setQuestionArray:self.questionArray];
    [vc setCurrentPosition:indexPath.row];
    
    NSLog(@"Sending question: %@ to answers VC", question.questionText);
    
    
}


@end
