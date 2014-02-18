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
#import "LayeredQuestion.h"

@interface QuestionsViewController ()

@property int chosenQuestion;
@property int buttonTag;

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

-(void)viewWillAppear:(BOOL)animated
{
    self.buttonTag = 0;
    [self.questionsTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Tableview Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.questionArray.count;
}

//Header Tapped Method
-(void)headerTapped:(UIButton *)sender{
    
    self.chosenQuestion = sender.tag;
    [self performSegueWithIdentifier:@"NewAuditQuestions" sender:self];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * customView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, tableView.frame.size.width, 100.0)];
    customView.backgroundColor = [UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 0.65];
    
    //make question text label
    Questions *question = [self.questionArray objectAtIndex:section];
    
    UILabel * questionLbl = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 0.0, 414.0, 89.0)];
    questionLbl.text = question.questionText;
    questionLbl.font = [UIFont fontWithName:@"Verdana" size:20.0];
    questionLbl.lineBreakMode = NSLineBreakByWordWrapping;
    questionLbl.numberOfLines = 0;
    
    [customView addSubview: questionLbl];
    
    
    //make points label
    UILabel * pointsLbl = [[UILabel alloc]initWithFrame:CGRectMake(463.0, 24.0, 160.0, 42.0)];
    
    if (question.isApplicable)
        pointsLbl.text = [NSString stringWithFormat:@"%.2f / %.2f", question.pointsAwarded,question.pointsPossible];
    else
        pointsLbl.text = @" 0 / 0 ";
    
    pointsLbl.font = [UIFont fontWithName:@"Verdana" size:16.0];
    pointsLbl.lineBreakMode = NSLineBreakByWordWrapping;
    pointsLbl.numberOfLines = 0;
    
    [customView addSubview: pointsLbl];
    
    
    //make checkmark imageview
    UIImageView * checkImage = [[UIImageView alloc]initWithFrame:CGRectMake(630.0, 15.0, 76.0, 60)];
    checkImage.image = [UIImage imageNamed:@"check.png"];
    
    if (question.isCompleted)
        checkImage.hidden = false;
    else
        checkImage.hidden = true;
    
    [customView addSubview: checkImage];
    
    /* make button one pixel less high than customView above, to account for separator line */
    UIButton * questionBtn = [[UIButton alloc] initWithFrame: CGRectMake(0.0, 0.0, tableView.frame.size.width, customView.frame.size.height)];
    [questionBtn setTag:self.buttonTag];
    self.buttonTag ++;
    
    [questionBtn setBackgroundColor:[UIColor clearColor]];
    [questionBtn addTarget:self action:@selector(headerTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    questionBtn.alpha = 1.0;
    [customView addSubview: questionBtn];
    
    return customView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 100.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    Questions * question = [self.questionArray objectAtIndex:section];
    
    int numOfLayered;
    
    if (question.layeredQuesions.count > 0) {
        self.allSublayeredQuestions = [NSMutableArray new];
        int throwAway = [self getNumOfSubQuestionsAndSetAllSubsArray:question layerDepth:1];
        
        numOfLayered = self.allSublayeredQuestions.count;
    }
    else
        numOfLayered = 0;
    
    return numOfLayered;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"QuestionCell";
    
    QuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[QuestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSLog(@"Section #: %d",indexPath.section);
    
    Questions * question = [self.questionArray objectAtIndex:indexPath.section];
    
    if (question.layeredQuesions > 0) {
        int throwAway = [self getNumOfSubQuestionsAndSetAllSubsArray:question layerDepth:1];
    
        LayeredQuestion * lQuestion = [self.allSublayeredQuestions objectAtIndex:indexPath.row];
        cell.questionText.text = lQuestion.question.questionText;
    
        if (lQuestion.question.isApplicable) {
            cell.points.text = [NSString stringWithFormat:@"%.2f / %.2f", lQuestion.question.pointsAwarded,lQuestion.question.pointsPossible];
        }
        else
        {
            cell.points.text = @" 0 / 0 ";
        }
    
        if (lQuestion.question.isCompleted)
        {
            cell.doneImage.hidden = NO;
        }
        else{
            cell.doneImage.hidden = YES;
        }
    }
    
    [cell.questionText setTextColor:[UIColor lightGrayColor]];
    cell.questionText.font = [UIFont fontWithName:@"Verdana" size:18.0];
    
    [cell.points setTextColor:[UIColor lightGrayColor]];
    cell.points.font = [UIFont fontWithName:@"Verdana" size:14.0];
    
    return cell;
}

#pragma mark - Segue Preparation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    AnswersViewController *vc = [segue destinationViewController];
    Questions *question = [self.questionArray objectAtIndex:self.chosenQuestion];
    

    [vc setElementNumber:self.elementNumber];
    [vc setSubElementNum:self.subEleNumber];
    
    [vc setQuestion:question];
    [vc setQuestionArray:self.questionArray];
    [vc setCurrentPosition:self.chosenQuestion];
    
    vc.audit = self.audit;
    
    NSLog(@"Sending question: %@ to answers VC", question.questionText);
    
}

#pragma mark - Helper Method

-(int) getNumOfSubQuestionsAndSetAllSubsArray:(Questions *)question layerDepth:(int)depth
{
    
    int n = 1;
    for (int i = 0; i < [question.layeredQuesions count]; i++)
    {
        LayeredQuestion *tempObject = [LayeredQuestion new];
        
        tempObject.question = [question.layeredQuesions objectAtIndex:i];
        [self.allSublayeredQuestions addObject:tempObject];
        
        if( tempObject.question.layeredQuesions.count > 0)
            depth++;
        
        n += [self getNumOfSubQuestionsAndSetAllSubsArray:tempObject.question layerDepth:depth];
        
        tempObject.subIndexes = [NSMutableArray new];
        for( int j = 1; j <= tempObject.question.layeredQuesions.count; j++ )
        {
            
            [tempObject.subIndexes addObject:[NSNumber numberWithInt: j + [self.allSublayeredQuestions indexOfObject:tempObject] ] ];
        }
    }
    
    return n;
}

@end
