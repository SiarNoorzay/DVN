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
#import "AuditIDObject.h"

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
    if (self.listOfElements != nil){
        
        for (int i = 0; i< [self.listOfElements count]; i++) {
            Elements *ele = [self.listOfElements objectAtIndex:i];
            float tempElePoints = 0;
            
            for (int j = 0; j<[ele.Subelements count];j++) {
                SubElements *subEle = [ele.Subelements objectAtIndex:j];
                float tempSubPoints = 0;
                
                for (int k = 0; k < [subEle.Questions count]; k++) {
                    Questions *question =[subEle.Questions objectAtIndex:k];
                    
                    if (!question.isApplicable) {
                        tempSubPoints += question.pointsPossible;
                        tempElePoints += question.pointsPossible;
                    }
                    subEle.modefiedNAPoints = tempSubPoints;
                }
                ele.modefiedNAPoints = tempElePoints;
                
                //TODO: save ele back to DB
            }
        }
    }
    
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
    
    if([self.audType isEqualToString:@"importWIP"])
    {
        _directoryPath = [self setFilePath];
        
        [[self restClient] loadFile:self.auditPath intoPath:_directoryPath];
    }
    else
    {
        [[self restClient] loadMetadata:self.auditPath];
    }

    [self.spinner startAnimating];
    
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
    self.ele = self.listOfElements[row];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 60)];
    UIColor *backColor = [[UIColor alloc]initWithRed:153.0 green:217.0 blue:239.0 alpha:.5];

    label.backgroundColor = backColor;
    label.textColor = [UIColor blackColor];
    label.tintColor = [UIColor greenColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25];
    label.text = self.ele.name; // ASCII 65 is "A"
    [label setTextAlignment:NSTextAlignmentCenter];
    
    return label;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    
    return [self.listOfElements count];
}

/*-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component{

    self.ele = [[Elements alloc]initWithElement:self.listOfElements[row]];

    return self.ele.name;
}*/

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.listOfSubElements = self.ele.Subelements;
    self.subElementIDs = [self.dnvDBManager getIDSFrom:@"SUBELEMENT" where:@"ELEMENTID" equals:(int)row];
    
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
    
}

#pragma mark file selection methods

-(void)loadDropboxFile:(NSString *)file{
    
    NSString *filename = [self.auditPath stringByAppendingPathComponent:file];
    
    NSLog(@"Filename: %@", filename);
    
    _directoryPath = [self setFilePath];
    
    [restClient loadFile:filename intoPath:_directoryPath];
}

-(NSString *)setFilePath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"sampleAuditFromDB.json"];
    
    return filePath;
    
}

#pragma mark Dropbox methods

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        
        DBMetadata * JSONFile = metadata.contents[0];
            
        NSLog(@"metadata content: %@", metadata.contents[0]);
        NSLog(@"JSONFile: %@", JSONFile.filename);
            
        [self loadDropboxFile:JSONFile.filename];
    }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}


- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath
       contentType:(NSString*)contentType metadata:(DBMetadata*)metadata {
    
    NSLog(@"File loaded into path: %@", localPath);
    [self getAudit];
    [self.spinner stopAnimating];
    
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    NSLog(@"There was an error loading the file - %@", error);
}

#pragma mark method to get the Audit Object

-(void)getAudit{
    if (_directoryPath) { // check if file exists - if so load it:
        NSError *error;
        
        NSString *stringData = [NSString stringWithContentsOfFile:_directoryPath encoding:NSUTF8StringEncoding error:&error];
        NSData *data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
        
//        NSLog(@"JSON contains:\n%@", [dictionary description]);
        
        NSDictionary *theAudit = [dictionary objectForKey:@"Audit"];
        
        //use this to access the audit and its components dictionary style
        Audit *aud = [[Audit alloc]initWithAudit:theAudit];
        self.auditSelectLbl.text = aud.name;
        
        //Just a DB test
        //Using the user defaults to create the audit ID
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * auditID = [NSString stringWithFormat:@"%@.%@.%@", [defaults objectForKey:@"currentClient"], [defaults objectForKey:@"currentAudit"], [defaults objectForKey:@"currentUser"]];
        auditID = [auditID stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [self.dnvDBManager saveAudit:aud];
        
        Audit * dbTestAudit = [self.dnvDBManager retrieveAudit:auditID];
        
        self.elementIDs = [self.dnvDBManager getElementIDS:auditID];
        
        NSLog(@"Audit Name: %@", dbTestAudit.name);
        //end of DB test
        
        
        self.listOfElements = aud.Elements;
        
        Audit *second = [[Audit alloc] initWithAudit:theAudit];
        
        //just to test
//         Audit *aha = [aud mergeAudit:aud with:second];
        
        //[self.elementPicker reloadAllComponents];
        
        
        [self.elementPicker reloadAllComponents];
        
        [self.elementPicker selectRow:0 inComponent:0 animated:false];
        Elements *tempEle = [self.listOfElements objectAtIndex:0];
        self.listOfSubElements = tempEle.Subelements;
        
        [self.subElementTable reloadData];

    }
    
}

@end
