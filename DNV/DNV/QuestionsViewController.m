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
#import "ElementSubElementViewController.h"



@interface QuestionsViewController ()

@end

@implementation QuestionsViewController


-(void)viewWillAppear:(BOOL)animated
{
    self.audit = [self.dnvDBManager retrieveAudit:self.audit.auditID];

    for(int i=0; i<self.questionArray.count; i++)
    {
        Questions *question = [self.questionArray objectAtIndex:i];

        question = [self.dnvDBManager retrieveQuestion:question.questionID];
    }
    [self.questionsTableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    ElementSubElementViewController *eleSubVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-1];
    
    if ([eleSubVC isKindOfClass:[ElementSubElementViewController class]]) {
        eleSubVC.aud = self.audit;

    }

    
}


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
    
    self.dnvDBManager = [DNVDatabaseManagerClass getSharedInstance];

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
    cell.questionText.numberOfLines = 0;
    
    NSString *text = question.questionText;
    
    // Get a CGSize for the width and, effectively, unlimited height
    CGSize constraint = cell.questionText.frame.size;
    constraint.height = 99999;

    // Get the size of the text given the CGSize we just made as a constraint
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Verdana" size:20.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    //how to use this??
    // CGSize size2 = [text boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(NSDictionary *)#> context:<#(NSStringDrawingContext *)#>]
    
    // Get the height of our measurement, with a minimum of 44 (standard cell size)
    CGFloat height = MAX(size.height, 44.0f);
    CGRect rect = cell.questionText.frame;
    rect.size.height = height + 44;
    
    cell.questionText.frame = rect;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: FIX THIS SHIET
    Questions * quest = [self.questionArray objectAtIndex:indexPath.row];
    
    // Get the text so we can measure it
    NSString *text = quest.questionText;
    QuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];

    // Get a CGSize for the width and, effectively, unlimited height
    CGSize constraint = cell.questionText.frame.size;
    constraint.height = 99999;
    
    // Get the size of the text given the CGSize we just made as a constraint
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Verdana" size:20.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    //how to use this??
    // CGSize size2 = [text boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(NSDictionary *)#> context:<#(NSStringDrawingContext *)#>]
    
    // Get the height of our measurement, with a minimum of 44 (standard cell size)
    CGFloat height = MAX(size.height, 44.0f);
    // return the height, with a bit of extra padding in
    return height + 44;

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
    [vc setQuestionArray:[NSMutableArray arrayWithArray:self.questionArray]];
    [vc setCurrentPosition:indexPath.row];
    
    vc.audit = self.audit;
    
    NSLog(@"Sending question: %@ to answers VC", question.questionText);
    
    
}


@end
