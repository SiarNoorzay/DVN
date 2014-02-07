//
//  VerifyQuestionsViewController.m
//  DNV
//
//  Created by USI on 1/14/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "VerifyQuestionsViewController.h"
#import "VerifyTabController.h"
#import "LayeredQuestion.h"

@interface VerifyQuestionsViewController ()
{
    Questions *selectedQuestion;
    int theSpot;
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
    
    self.dnvDB = [DNVDatabaseManagerClass getSharedInstance];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.audit != nil){
        BOOL auditComplete = true;
        for (int i = 0; i< [self.audit.Elements count]; i++) {
            Elements *ele = [self.audit.Elements objectAtIndex:i];
            float tempEleNAPoints = 0;
            float elePointsAwarded = 0;
            BOOL eleComplete = true;
            
            for (int j = 0; j<[ele.Subelements count];j++) {
                SubElements *subEle = [ele.Subelements objectAtIndex:j];
                float tempSubNAPoints = 0;
                float subElePointsAwarded = 0;
                BOOL subEleComplete = true;
                
                for (int k = 0; k < [subEle.Questions count]; k++) {
                    Questions *question =[subEle.Questions objectAtIndex:k];
                    
                    if (!question.isApplicable) {
                        tempSubNAPoints += question.pointsPossible;
                        tempEleNAPoints += question.pointsPossible;
                    }
                    if (!question.isCompleted){
                        subEleComplete = false;
                    }
                    if (question.layeredQuesions.count >0) {
                        //reset all sublayerd questions and loop thru them adding points to subelePoints
                        self.allSublayeredQuestions = [NSMutableArray new];
                        int numOfSubs = [self getNumOfSubQuestionsAndSetAllSubsArray:question layerDepth:0];
                        
                        for (LayeredQuestion *layQ in self.allSublayeredQuestions) {
                            subElePointsAwarded += layQ.question.pointsAwarded;
                            if (!layQ.question.isApplicable) {
                                tempSubNAPoints += layQ.question.pointsPossible;
                                tempEleNAPoints += layQ.question.pointsPossible;
                            }
                            
                        }
                        NSLog(@"Subele: %d naPoints: %f",j,tempSubNAPoints);
                    }
                    subElePointsAwarded += question.pointsAwarded;
                }
                subEle.modefiedNAPoints = tempSubNAPoints;
                subEle.pointsAwarded = subElePointsAwarded;
                elePointsAwarded += subElePointsAwarded;
                subEle.isCompleted = subEleComplete;
                eleComplete = eleComplete && subEleComplete;
                
                [self.dnvDB updateSubElment:subEle];
                
            }
            ele.modefiedNAPoints = tempEleNAPoints;
            ele.pointsAwarded = elePointsAwarded;
            
            [self.dnvDB updateElement:ele];
            
            auditComplete = auditComplete && eleComplete;
        }//end of element loop
        if (auditComplete) {
            self.audit.auditType = 2;
        }
    }
    if (self.dnvDB)
    {
        [self.dnvDB updateAudit:self.audit];
    }
}

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
    theSpot = indexPath.row;
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
        destVC.listOfVerifyQuestions = self.verifyQuestions;
        destVC.currentSpot = theSpot;
    }
}

@end
