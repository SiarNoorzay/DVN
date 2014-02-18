//
//  ListOfCompletedViewController.m
//  DNV
//
//  Created by USI on 1/15/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ListOfCompletedViewController.h"
#import <DropboxSDK/DropboxSDK.h>

#import "EditClientViewController.h"
#import "ElementSubElementViewController.h"
#import "CompletedChoicePopOver.h"
#import "Folder.h"
#import "TitleViewController.h"
#import "LayeredQuestion.h"
#import "VerifyQuestionsViewController.h"

@interface ListOfCompletedViewController ()<DBRestClientDelegate>

@property int chosenCompleted;
@property NSString * completedType;
@property NSString * chosenCompletedPath;

@end

@implementation ListOfCompletedViewController

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
    
    self.sectionHeaders = [[NSArray alloc]initWithObjects:@"On Device",@"From Dropbox", nil];
    
    NSLog(@"\n\nFolder Path recieved: %@", self.dbCompletedFolderPath);
    
    self.completedAuditTable.delegate = self;
    
    //local Completed
    self.dnvDBManager = [DNVDatabaseManagerClass getSharedInstance];
    
    //Checks for internect connectivity when the View Appears
    if ([self.navigationController.navigationBar.backgroundColor isEqual:[UIColor greenColor]]){
    
        [[self restClient] loadMetadata:self.dbCompletedFolderPath];
        [self.spinner startAnimating];
        [self.completedAuditTable reloadData];
    }
    else
        [self.spinner stopAnimating];
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSArray * distinctCompleted = [self.dnvDBManager retrieveDistinctAuditNamesForClientOfType:2];
    for (NSString * distinct in distinctCompleted)
        self.localCompleted = [self.dnvDBManager retrieveAllAuditIDsOfType:2 forAuditName:distinct];
    
    [self.completedAuditTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.sectionHeaders.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.sectionHeaders[section];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int numberOfRows;
    
    if (section == 0){
        numberOfRows = (int)[self.localCompleted count];
    }
    else {
        numberOfRows = (int)[self.completed count];
    }
    
    return numberOfRows;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellIdentifier = @"CompletedCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if(indexPath.section == 0)
        cell.textLabel.text = self.localCompleted[indexPath.row];
    else if(indexPath.section == 1){
        Folder * comp = [self.completed objectAtIndex:indexPath.row];
        
        cell.textLabel.text = comp.name;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:25.0];
    //    cell.imageView.image = [UIImage imageNamed:@"check-mark-button.png"];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults *nsDefaults = [NSUserDefaults standardUserDefaults];
    
    if (indexPath.section == 0) {
        self.completedType = @"localCompleted";
        self.audit = [self.dnvDBManager retrieveAudit:self.localCompleted[indexPath.row]];
        
        [nsDefaults setObject:self.audit.name forKey:@"currentAudit"];
        [nsDefaults synchronize];
    }
    else{
        self.completedType = @"importCompleted";
        Folder *temp =[self.completed objectAtIndex:indexPath.row];
        
        [nsDefaults setObject:temp.name forKey:@"currentAudit"];
        [nsDefaults synchronize];
        
        NSLog(@"Path of Audit: %@", temp.folderPath);
        self.chosenCompletedPath = temp.folderPath;
        
        [[self restClient2] loadMetadata:self.chosenCompletedPath];
    }
    
    self.chosenCompleted = indexPath.row;
    
    CompletedChoicePopOver * completedPopContent = [self.storyboard instantiateViewControllerWithIdentifier:@"completedChoices"];
    
    completedPopContent.completedAuditVC = self;
    completedPopContent.compType = self.completedType;
    
    self.completedPopOver = [[UIPopoverController alloc] initWithContentViewController:completedPopContent];
    self.completedPopOver.delegate = self;
    
    UITableViewCell * cell = [self.completedAuditTable cellForRowAtIndexPath:indexPath];
    
    [self.completedPopOver setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35]];
    [self.completedPopOver presentPopoverFromRect:cell.frame inView:self.completedAuditTable permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
    
}


#pragma mark Dropbox methods

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

- (DBRestClient*)restClient2 {
    if (restClient2 == nil) {
        restClient2 = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient2.delegate = self;
    }
    return restClient2;
}

- (DBRestClient*)restClient3 {
    if (restClient3 == nil) {
        restClient3 = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient3.delegate = self;
    }
    return restClient3;
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (client == self->restClient){
        if (metadata.isDirectory) {
            NSLog(@"Folder '%@' contains:", metadata.path);
            NSMutableArray *completedList = [[NSMutableArray alloc]init];
            for (DBMetadata *file in metadata.contents) {
                if (file.isDirectory) {
                    Folder *folder = [[Folder alloc]init];
                    folder.folderPath = file.path;
                    folder.contents = file.contents;
                    folder.name = file.filename;
                    NSLog(@"	%@", file.filename);
                    [completedList addObject:folder];
                }
            }
        
            self.completed = completedList;
            [self.completedAuditTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
        [self.spinner stopAnimating];
    }
    else if (client == self->restClient2){
        
        for (int i = 0; i < metadata.contents.count; i++){
            
            DBMetadata * JSONFile = metadata.contents[i];
            
            if ([JSONFile.filename rangeOfString:@".json"].location != NSNotFound){
                NSLog(@"JSONFile: %@", JSONFile.filename);
    
                [self loadDropboxFile:JSONFile.filename];
                break;
            }
        }
    }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath
       contentType:(NSString*)contentType metadata:(DBMetadata*)metadata {
    
    NSLog(@"File loaded into path: %@", localPath);
    if (client == self->restClient)
        [self getAudit];
    
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    NSLog(@"There was an error loading the file - %@", error);
}

#pragma mark WIP selection methods

-(void)goToCompletedChoice
{
    switch (self.completedChoice) {
        case 0:
            [self performSegueWithIdentifier:@"EditClient" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"EditQuestions" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"ViewReport" sender:self];
            break;
        case 3:
        {
            UIAlertView * deleteAuditAlert = [[UIAlertView alloc] initWithTitle: @"Delete Audit On Device" message: @"Are you sure you would like to delete this audit from local storage?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
            
            [deleteAuditAlert show];
        }
            break;
        case 4:
        {
            [self performSegueWithIdentifier:@"completedToListVerify" sender:self];
            break;
        }
        default:
            break;
    }
}

#pragma mark Alertview method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //Code for OK button
    }
    if (buttonIndex == 1)
    {
        [self.dnvDBManager deleteAudit:self.audit.auditID];
        UIAlertView * deleteAuditNotice = [[UIAlertView alloc] initWithTitle:@"Audit Deleted" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [deleteAuditNotice show];
        
        [self.dnvDBManager deleteAudit:self.localCompleted[self.chosenCompleted]];
        [self.localCompleted removeObjectAtIndex:self.chosenCompleted];
        [self.completedAuditTable reloadData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
 
    [defaults synchronize];
    
    if ([segue.identifier isEqualToString:@"EditClient"]) {
        
        EditClientViewController * editClientVC = [segue destinationViewController];
        
        editClientVC.client = self.audit.client;
        editClientVC.report = self.audit.report;
        editClientVC.auditID = self.audit.auditID;
    }
    
    if ([segue.identifier isEqualToString:@"EditQuestions"]){
        
        ElementSubElementViewController * eleSubEleVC = [segue destinationViewController];
        
        eleSubEleVC.aud = self.audit;
        
        NSLog(@"Audit Name: %@", self.audit.name);
        
    }
    if ([segue.identifier isEqualToString:@"ViewReport"]) {
        
        TitleViewController * titleVC = [segue destinationViewController];
        
        titleVC.audit = self.audit;
    }
    
}


#pragma mark file selection methods

-(void)loadDropboxFile:(NSString *)file{
    
    NSString *filename = [self.chosenCompletedPath stringByAppendingPathComponent:file];
    
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

-(NSString *)setAttachPath:(NSString *)attachment{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    NSString *attachPath = [documentsDirectory stringByAppendingPathComponent:attachment];
    
    return attachPath;
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
        
        //import attachments locally and change attachment audit paths
        self.audit = [self formatAndImportAttachmentsAndImages:self.audit];
        
        //saving imported audit to database
        [self.dnvDBManager saveAudit:self.audit];
        
        //retrieving audit from database to populate ids
        self.audit = [self.dnvDBManager retrieveAudit:self.audit.auditID];
        
        NSLog(@"Audit Name: %@", self.audit.name);
        //end of DB test
        
    }
}

-(Audit*)formatAndImportAttachmentsAndImages:(Audit*)aud //to:(NSString*)path
//imports all images and attachments to DBox and changes arrays in audit to hold Dbox locations
{
    for (int i=0; i<aud.Elements.count; i++) {
        Elements *ele = [aud.Elements objectAtIndex:i];
        
        for (int j=0 ; j<ele.Subelements.count; j++) {
            SubElements *subEle = [ele.Subelements objectAtIndex:j];
            
            for (int k = 0; k<subEle.Questions.count; k++) {
                Questions *question = [subEle.Questions objectAtIndex:k];
                
                //loop through sublayers
                self.allSublayeredQuestions = [NSMutableArray new];
                int throwAway = [self getNumOfSubQuestionsAndSetAllSubsArray:question layerDepth:1];
                for (int l = 0; l<self.allSublayeredQuestions.count; l++) {
                    LayeredQuestion *layQ = [self.allSublayeredQuestions objectAtIndex:l];
                    NSMutableArray *tempImageArr = [NSMutableArray arrayWithArray: layQ.question.imageLocationArray];
                    
                    for (int m = 0; m<tempImageArr.count ; m++)
                    {
                        NSString *pathFrom = [tempImageArr objectAtIndex:m];
                        pathFrom = [self importFile:pathFrom];
                        [tempImageArr setObject:pathFrom atIndexedSubscript:m];
                    }
                    layQ.question.imageLocationArray = tempImageArr;
                    
                    NSMutableArray *tempAttachArr = [NSMutableArray arrayWithArray: layQ.question.attachmentsLocationArray];
                    
                    for (int m = 0; m<tempAttachArr.count ; m++)
                    {
                        NSString *pathFrom = [tempAttachArr objectAtIndex:m];
                        pathFrom = [self importFile:pathFrom];
                        [tempAttachArr setObject:pathFrom atIndexedSubscript:m];
                    }
                    layQ.question.attachmentsLocationArray = tempAttachArr;
                    
                    NSMutableArray *tempDrawnLocs = [NSMutableArray arrayWithArray: layQ.question.drawnNotes];
                    
                    for (int m = 0; m<tempDrawnLocs.count ; m++)
                    {
                        NSString *pathFrom = [tempDrawnLocs objectAtIndex:m];
                        pathFrom = [self importFile:pathFrom];
                        [tempDrawnLocs setObject:pathFrom atIndexedSubscript:m];
                    }
                    layQ.question.drawnNotes = tempDrawnLocs;
                    
                }//sublayer loop
                
                //need to go through main question as well
                NSMutableArray *tempImageArr = [NSMutableArray arrayWithArray: question.imageLocationArray];
                
                for (int m = 0; m<tempImageArr.count ; m++)
                {
                    NSString *pathFrom = [tempImageArr objectAtIndex:m];
                    pathFrom = [self importFile:pathFrom];
                    [tempImageArr setObject:pathFrom atIndexedSubscript:m];
                }
                question.imageLocationArray = tempImageArr;
                
                NSMutableArray *tempAttachArr = [NSMutableArray arrayWithArray:question.attachmentsLocationArray];
                
                for (int m = 0; m<tempAttachArr.count ; m++)
                {
                    NSString *pathFrom = [tempAttachArr objectAtIndex:m];
                    pathFrom = [self importFile:pathFrom];
                    [tempAttachArr setObject:pathFrom atIndexedSubscript:m];
                }
                question.attachmentsLocationArray = tempAttachArr;
                
                NSMutableArray *drawnLoc = [NSMutableArray arrayWithArray:question.drawnNotes];
                
                for (int m = 0; m<drawnLoc.count ; m++)
                {
                    NSString *pathFrom = [drawnLoc objectAtIndex:m];
                    pathFrom = [self importFile:pathFrom];
                    [drawnLoc setObject:pathFrom atIndexedSubscript:m];
                }
                question.drawnNotes = drawnLoc;
            }//question loop
        }
    }
    return aud;
}

-(NSString*)importFile:(NSString*)dropboxPath// withFile:(NSString*)fileName
{
//    self.numberOfUploadsLeft ++;
    //get file name from last string chunk
    NSArray *chunks = [dropboxPath componentsSeparatedByString: @"/"];
    
    NSString *fileName = [chunks objectAtIndex:[chunks count]-1];
    
    NSString * internalPath = [self setAttachPath:fileName];
    
    //[[self restClient2] uploadFile:fileName toPath:dropboxPath withParentRev:nil fromPath:internalPath];
    
    //using this deprecated method since it overwrites instead of renaming
    [[self restClient3] loadFile:dropboxPath intoPath:internalPath];
    
    return internalPath;
    
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

@end
