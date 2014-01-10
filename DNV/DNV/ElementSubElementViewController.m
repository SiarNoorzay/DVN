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

#import "Questions.h"
#import "Folder.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"Audit Path: %@", self.auditPath);
    
    NSString *filename = [self.auditPath stringByAppendingPathComponent:@"sampleAudit.json"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"sampleAuditFromDB.json"];
    _directoryPath = filePath;
    
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }

    [restClient loadFile:filename intoPath:filePath];
    
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

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    
    return [self.listOfElements count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component{

    self.ele = [[Elements alloc]initWithElement:self.listOfElements[row]];

    return self.ele.name;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.listOfSubElements = self.ele.Subelements;
    
    [self.subElementTable reloadData];
    elementNumber = row;
}

#pragma maker Tableview methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.listOfSubElements count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"AuditCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    self.subEle = [[SubElements alloc]initWithSubElement:self.listOfSubElements[indexPath.row]];
    
    cell.textLabel.text = self.subEle.name;
    //    cell.imageView.image = [UIImage imageNamed:@"check-mark-button.png"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    subEleNumber = indexPath.row;
    
    [self performSegueWithIdentifier:@"toQuestions" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = self.subElementTable.indexPathForSelectedRow;
    
    QuestionsViewController * questionsVC = [segue destinationViewController];
    
    self.subEle = [[SubElements alloc]initWithSubElement:self.listOfSubElements[indexPath.row]];
    questionsVC.questionArray = self.subEle.Questions;
    questionsVC.elementNumber = elementNumber;
    questionsVC.subEleNumber = subEleNumber;
    
}


#pragma mark Dropbox methods

//- (DBRestClient*)restClient {
//    if (restClient == nil) {
//        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
//        restClient.delegate = self;
//    }
//    return restClient;
//}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
//        NSLog(@"Folder '%@' contains:", metadata.path);
//        NSMutableArray *auditList = [[NSMutableArray alloc]init];
//        for (DBMetadata *file in metadata.contents) {
//            if (file.isDirectory) {
//                Folder *folder = [[Folder alloc]init];
//                folder.folderPath = file.path;
//                folder.contents = file.contents;
//                folder.name = file.filename;
//                NSLog(@"	%@", file.filename);
//                [auditList addObject:folder];
//            }
//            
//        }
//        self.audits = auditList;
//        
//        //   [self.auditListTable reloadData];
//        [self.auditListTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
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
        
        self.listOfElements = aud.Elements;
        
        //[self.elementPicker reloadAllComponents];
        
        [self.elementPicker selectRow:0 inComponent:0 animated:false];
        
        [self.elementPicker reloadAllComponents];
        

    }
    
}

@end
