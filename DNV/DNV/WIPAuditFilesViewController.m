//
//  WIPAuditFilesViewController.m
//  DNV
//
//  Created by USI on 1/13/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "WIPAuditFilesViewController.h"
#import <DropboxSDK/DropboxSDK.h>

#import "WIPChoicePopOver.h"
#import "ElementSubElementViewController.h"
#import "VerifyQuestionsViewController.h"
#import "ImportMergeViewController.h"

@interface WIPAuditFilesViewController ()<DBRestClientDelegate>

@property int chosenJSONfile;

@end

@implementation WIPAuditFilesViewController

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
    
    [self.spinner startAnimating];
    
    if ([self.wipAuditType isEqualToString:@"importWIP"]){
        [[self restClient] loadMetadata:self.wipAuditPath];
    }
    else if ([self.wipAuditType isEqualToString:@"localWIP"]){
        self.localWIPList = [self.dnvDBManager retrieveAllAuditIDsOfType:1 forAuditName:self.localWIPName];
        
        [self.wipJSONFileTable reloadData];
        [self.spinner stopAnimating];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int rowCount;
    
    if ([self.wipAuditType isEqualToString:@"localWIP"])
         rowCount = [self.localWIPList count];
    
    if ([self.wipAuditType isEqualToString:@"importWIP"])
        rowCount = [self.JSONList count];
    
    return rowCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"WIPAuditCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if ([self.wipAuditType isEqualToString:@"localWIP"])
        cell.textLabel.text = self.localWIPList[indexPath.row];
    
    if ([self.wipAuditType isEqualToString:@"importWIP"])
        cell.textLabel.text = self.JSONList[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:25.0];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.chosenJSONfile = indexPath.row;
    
    if ([self.wipAuditType isEqualToString:@"localWIP"]){
        
        self.audit = [self.dnvDBManager retrieveAudit:self.localWIPList[self.chosenJSONfile]];
    }
    
    if ([self.wipAuditType isEqualToString:@"importWIP"]){
        
        [self loadDropboxFile:self.JSONList[self.chosenJSONfile]];
    }
    
    WIPChoicePopOver * wipPopContent = [self.storyboard instantiateViewControllerWithIdentifier:@"wipChoices"];
    
    wipPopContent.WIPAuditFilesVC = self;
    
    self.wipPopOver = [[UIPopoverController alloc] initWithContentViewController:wipPopContent];
    
    self.wipPopOver.delegate = self;
    
    UITableViewCell * cell = [self.wipJSONFileTable cellForRowAtIndexPath:indexPath];
    
    [self.wipPopOver setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35]];
    
    [self.wipPopOver presentPopoverFromRect:cell.frame inView:self.wipJSONFileTable permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
    
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
        self.JSONList = [[NSMutableArray alloc]init];
        for (DBMetadata * file in metadata.contents) {
            [self.JSONList addObject:file.filename];
        }
    }
    
    [self.wipJSONFileTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self.spinner stopAnimating];
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

#pragma mark WIP selection methods

-(void)goToWIPChoice
{
    switch (self.wipJSONChoice) {
        case 0:
            [self performSegueWithIdentifier:@"ContinueAudit" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"VerifyQuestions" sender:self];
            break;
        case 2:
        {
            //TODO: convert selected audit back from audit->dictionary->json and export to dropbox
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Dropbox Export Complete" message: @"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
            break;
        case 3:
            [self performSegueWithIdentifier:@"ImportMerge" sender:self];
            break;
            
        default:
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"ContinueAudit"]) {
        ElementSubElementViewController * eleSubEleVC = [segue destinationViewController];
        
        eleSubEleVC.aud = self.audit;
        
    }
    
//    if ([segue.identifier isEqualToString:@"VerifyQuestions"]){
//        
//        
//    }
    
    if ([segue.identifier isEqualToString:@"ImportMerge"]){
        
        ImportMergeViewController * importVC = [segue destinationViewController];
        
        importVC.jsonFiles = self.JSONList;
        importVC.localFiles = self.localWIPList;
        importVC.currentFileType = self.wipAuditType;
        if ([self.wipAuditType isEqualToString:@"importWIP"]) {
            importVC.currentFile = self.JSONList[self.chosenJSONfile];
        }
        else if ([self.wipAuditType isEqualToString:@"localWIP"]){
            importVC.currentFile = self.localWIPList[self.chosenJSONfile];
        }
    }
    
//    NSIndexPath *indexPath = self.subElementTable.indexPathForSelectedRow;
//    
//    QuestionsViewController * questionsVC = [segue destinationViewController];
//    
//    self.subEle = [[SubElements alloc]initWithSubElement:self.listOfSubElements[indexPath.row]];
//    questionsVC.questionArray = self.subEle.Questions;
}

#pragma mark file selection methods

-(void)loadDropboxFile:(NSString *)file{
    
    NSString *filename = [self.wipAuditPath stringByAppendingPathComponent:file];
    
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

-(void)getAudit{
    if (_directoryPath) { // check if file exists - if so load it:
        NSError *error;
        
        NSString *stringData = [NSString stringWithContentsOfFile:_directoryPath encoding:NSUTF8StringEncoding error:&error];
        NSData *data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
        
        //        NSLog(@"JSON contains:\n%@", [dictionary description]);
        
        NSDictionary *theAudit = [dictionary objectForKey:@"Audit"];
        
        //use this to access the audit and its components dictionary style
        self.audit = [[Audit alloc]initWithAudit:theAudit];
        
        
        
        [self.dnvDBManager saveAudit:self.audit];
        
        self.audit = [self.dnvDBManager retrieveAudit:self.audit.auditID];
        
        NSLog(@"Audit Name: %@", self.audit.name);
        //end of DB test
        
    }
}

@end
