//
//  ElementSubElementViewController.m
//  DNV
//
//  Created by USI on 1/8/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ElementSubElementViewController.h"
#import "QuestionsViewController.h"
#import <DropboxSDK/DropboxSDK.h>

#import "SubElementCell.h"
#import "Questions.h"
#import "Folder.h"
#import "LayeredQuestion.h"

@interface ElementSubElementViewController ()<DBRestClientDelegate>

@property (nonatomic, readonly) DBRestClient * restClient;

@end
int elementNumber;
int subEleNumber;

@implementation ElementSubElementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self refreshView];
}

-(void)refreshView
{
    //updating Elements and subelements
    //self.listOfElements = self.aud.Elements;
    
    if (self.aud.Elements != nil){
        BOOL auditComplete = true;
        for (int i = 0; i< [self.aud.Elements count]; i++) {
            Elements *ele = [self.aud.Elements objectAtIndex:i];
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
                
                if( subEle.pointsPossible == subEle.modefiedNAPoints)
                    subEle.isApplicable = false;
                else
                    subEle.isApplicable = true;
                
                [self.dnvDBManager updateSubElment:subEle];
                
            }
            ele.modefiedNAPoints = tempEleNAPoints;
            ele.pointsAwarded = elePointsAwarded;
            ele.isCompleted = eleComplete;
            
            if( ele.pointsPossible == ele.modefiedNAPoints)
                ele.isApplicable = false;
            else
                ele.isApplicable = true;
    
            if( self.ele == ele)
            {
                if( !ele.isApplicable)
                    [self.naForElements setBackgroundImage:[UIImage imageNamed:@"not_applicable_icon"] forState:UIControlStateNormal];
                else
                    [self.naForElements setBackgroundImage:[UIImage imageNamed:@"not_applicable_icon_gray"] forState:UIControlStateNormal];
            }
            
            [self.dnvDBManager updateElement:ele];
            
            auditComplete = auditComplete && eleComplete;
        }//end of element loop
        if (auditComplete) {
            self.aud.auditType = 2;
        }
        else self.aud.auditType = 1;
    }
    if (self.dnvDBManager)
    {
        [self.dnvDBManager updateAudit:self.aud];
    }
    
    [self.subElementTable reloadData];
    [self.elementPicker reloadAllComponents];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"Audit Path: %@", self.auditPath);
    NSLog(@"Audit Type: %@", self.audType);
    
//    if (restClient == nil) {
//        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
//        restClient.delegate = self;
//    }
    
//    [self loadDropboxFile:self.auditPath];
    
    NSLog(@"Audit Name: %@",self.aud.name);
    self.auditSelectLbl.text = self.aud.name;
    self.listOfElements = self.aud.Elements;
    [self.elementPicker reloadAllComponents];
        
    [self.elementPicker selectRow:0 inComponent:0 animated:false];
    Elements *tempEle = [self.listOfElements objectAtIndex:0];
    self.listOfSubElements = tempEle.Subelements;
    [self.subElementTable reloadData];
    [self.spinner stopAnimating];
    
    if ([self.listOfElements count] > 0) {
        self.ele = self.listOfElements[0];
    }

    
    self.dnvDBManager = [DNVDatabaseManagerClass getSharedInstance];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Picker View methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    Elements *rowELE = self.listOfElements[row];
    
    //A view to house the necessary contents of a row in the element picker:  n/a button, element name label, points attained, completed image,
    UIView *aPickerRow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 650, 80)];

    //element name label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 450, 50)];
    UIColor *backColor = [[UIColor alloc]initWithRed:153.0 green:217.0 blue:239.0 alpha:.5];

    label.backgroundColor = backColor;
    label.textColor = [UIColor blackColor];
    label.tintColor = [UIColor greenColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25];
    label.text = rowELE.name; // ASCII 65 is "A"
    [label setTextAlignment:NSTextAlignmentCenter];
    
    //percentage
    UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(465, 15, 140, 50)];
    [percentLabel setText:[NSString stringWithFormat:@"%.2f / %.2f", rowELE.pointsAwarded, rowELE.pointsPossible-rowELE.modefiedNAPoints]];
    
    //Add all views to main view
    [aPickerRow addSubview:label];
    [aPickerRow addSubview:percentLabel];
    
    //check image. create and add if element is completed or N/A'ed
    if( !rowELE.isApplicable || rowELE.isCompleted )
    {
        UIImageView *completed = [[UIImageView alloc] initWithFrame:CGRectMake(595, 15, 50, 50)];
        [completed setImage:[UIImage imageNamed:@"check"]];
        
        [aPickerRow addSubview:completed];
    }
    
    return aPickerRow;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 100;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    
    return [self.listOfElements count];
}



-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component{

    NSLog(@"gg");
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.ele = self.listOfElements[row];
    self.listOfSubElements = self.ele.Subelements;
    
    if( !self.ele.isApplicable)
        [self.naForElements setBackgroundImage:[UIImage imageNamed:@"not_applicable_icon"] forState:UIControlStateNormal];
    else
        [self.naForElements setBackgroundImage:[UIImage imageNamed:@"not_applicable_icon_gray"] forState:UIControlStateNormal];
    
    [self.subElementTable reloadData];
    elementNumber = row;
}

#pragma maker Tableview methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.listOfSubElements count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"SubElementCell";
    
    SubElementCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[SubElementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    self.subEle = self.listOfSubElements[indexPath.row];
    
    cell.subElementName.text = self.subEle.name;
    cell.points.text = [NSString stringWithFormat:@"%.2f / %.2f", self.subEle.pointsAwarded,(self.subEle.pointsPossible - self.subEle.modefiedNAPoints)];
    //cell.textLabel.font = [UIFont systemFontOfSize:25.0];
    
    if (self.subEle.isCompleted)
    {
        cell.image.hidden = NO;
    }
    else
    {
        cell.image.hidden = YES;
    }
    
    cell.theElementSubElementVC = self;
    cell.theSubElement = self.subEle;
    
    [cell setNAImage:self.subEle.isApplicable];
 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    subEleNumber = indexPath.row;
    
   // [self performSegueWithIdentifier:@"toQuestions" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = self.subElementTable.indexPathForSelectedRow;
    
    QuestionsViewController * questionsVC = [segue destinationViewController];
    
    self.subEle = self.listOfSubElements[indexPath.row];
    questionsVC.questionArray = self.subEle.Questions;
    questionsVC.elementNumber = elementNumber;
    questionsVC.subEleNumber = subEleNumber;
    questionsVC.audit = self.aud;
    
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


//NA all questions in an Element
- (IBAction)naForElements:(id)sender
{
    Elements *currentElement = [self.listOfElements objectAtIndex:elementNumber];
    currentElement.isApplicable = !currentElement.isApplicable;
    
    for( SubElements *se in currentElement.Subelements)
    {
        [self setNAToSubElementsQuestions:se ifBool:currentElement.isApplicable];
    }
    
    [self refreshView];
}

//NA all questions in a subelemnt
-(void)setNAToSubElementsQuestions:(SubElements*)aSubElement ifBool: (BOOL) setNA
{
    for( Questions *Quest in aSubElement.Questions )
    {
        [self setNAToQuestions:Quest ifBool:setNA];
    }
    
    aSubElement.isApplicable = setNA;
}
-(void)setNAToQuestions:(Questions*)aQuestion ifBool: (BOOL) setNA
{
    for( Questions *LayerQuestion in aQuestion.layeredQuesions )
    {
        [self setNAToQuestions:LayerQuestion ifBool:setNA];
    }
    
    if( !setNA)
    {
        aQuestion.isApplicable = false;
        aQuestion.isThumbsDown = false;
        aQuestion.isThumbsUp = false;
        aQuestion.needsVerifying =false;
        aQuestion.pointsAwarded = 0;
        aQuestion.isCompleted = true;
        
        
        //Might not be needed, but added just incase
        [self.dnvDBManager deleteVerifyForQuestion:aQuestion.questionID ofType:0];
        [self.dnvDBManager deleteVerifyForQuestion:aQuestion.questionID ofType:1];
        [self.dnvDBManager deleteVerifyForQuestion:aQuestion.questionID ofType:2];
    }
    else
    {
        aQuestion.isApplicable = true;
        aQuestion.isThumbsDown = false;
        aQuestion.isThumbsUp = false;
        aQuestion.needsVerifying =false;
        aQuestion.pointsAwarded = 0;
        aQuestion.isCompleted = false;
    }
    
    [self.dnvDBManager updateQuestion:aQuestion];
}

@end
