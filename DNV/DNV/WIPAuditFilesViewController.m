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
#import "LayeredQuestion.h"


@interface WIPAuditFilesViewController ()<DBRestClientDelegate>

@property int chosenJSONfile;

@property int numberOfUploadsLeft;

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
    self.numberOfUploadsLeft = 0;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.dnvDBManager = [DNVDatabaseManagerClass getSharedInstance];
    
    [self.spinner startAnimating];
    
    NSUserDefaults *nsDefaults = [NSUserDefaults standardUserDefaults];
    self.wipAuditPath = [NSString stringWithFormat:@"%@%@",self.wipAuditPath, [nsDefaults objectForKey:@"currentAudit"]];
    
    
    NSLog(@"WIP Path: %@", self.wipAuditPath);
    [[self restClient] loadMetadata:self.wipAuditPath];
    
    self.localWIPList = [self.dnvDBManager retrieveAllAuditIDsOfType:1 forAuditName:self.localWIPName];
        
    [self.wipJSONFileTable reloadData];
    
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
    BOOL dropBoxPicked;
    if ([self.wipAuditType isEqualToString:@"localWIP"]){
        dropBoxPicked = false;
        self.audit = [self.dnvDBManager retrieveAudit:self.localWIPList[self.chosenJSONfile]];
    }
    
    if ([self.wipAuditType isEqualToString:@"importWIP"]){
        dropBoxPicked = true;
        [self loadDropboxFile:self.JSONList[self.chosenJSONfile]];
    }
    
    WIPChoicePopOver * wipPopContent = [self.storyboard instantiateViewControllerWithIdentifier:@"wipChoices"];
    
    wipPopContent.WIPAuditFilesVC = self;
    [wipPopContent setDropBoxSelected:dropBoxPicked];
    
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
    
    if (metadata.isDirectory) {
        self.JSONList = [[NSMutableArray alloc]init];
        for (DBMetadata * file in metadata.contents) {
            if ([file.filename rangeOfString:@".json"].location != NSNotFound)
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
    
    if (client == self->restClient)
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
        {

            [self performSegueWithIdentifier:@"VerifyQuestions" sender:self];
        }
            break;
        case 2:
        {
            NSLog(@"%@",self.wipAuditPath);
            if ([self.wipAuditPath rangeOfString:self.audit.name].location == NSNotFound) {
               self.wipAuditPath = [self.wipAuditPath stringByAppendingString:[NSString stringWithFormat:@"%@/",self.audit.name]];
            } else {
                NSLog(@"string contains bla!");
            }

            //callback methods call the export method
            [self.spinner startAnimating];
            [[self restClient] createFolder:self.wipAuditPath];

            
        }
            break;
        case 3:
            [self performSegueWithIdentifier:@"ImportMerge" sender:self];
            break;
            
        default:
            break;
    }
}

-(NSMutableArray*)getVerifyQuestionsForAudit:(Audit*)anAudit
{
    NSMutableArray *verifyQuestions = [NSMutableArray new];
    
    for( Elements *Elem in anAudit.Elements)
    {
        for ( SubElements *SubElem in Elem.Subelements )
        {
            for( Questions *Quest in SubElem.Questions )
            {
                [self getAllVerifiedQuestionsFromQuestion:Quest forVerifyArray:verifyQuestions];
            }
        }
    }

    return verifyQuestions;
}
-(void)getAllVerifiedQuestionsFromQuestion:(Questions*)aQuestion forVerifyArray:(NSMutableArray*)vArray
{
    for( Questions *LayerQuestion in aQuestion.layeredQuesions )
    {
        [self getAllVerifiedQuestionsFromQuestion:LayerQuestion forVerifyArray:vArray];
    }
        
    if ( aQuestion.needsVerifying > 0)
    {
        [vArray addObject:aQuestion];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"ContinueAudit"]) {
        ElementSubElementViewController * eleSubEleVC = [segue destinationViewController];
        
        eleSubEleVC.aud = self.audit;
        
    }
    
    if ([segue.identifier isEqualToString:@"ImportMerge"]){
        
        ImportMergeViewController * importVC = [segue destinationViewController];
        
        importVC.jsonFiles = self.JSONList;
        importVC.localFiles = self.localWIPList;
        importVC.currentFileType = self.wipAuditType;
        importVC.currentAudit = self.audit;
        importVC.wipPath = self.wipAuditPath;
        
        if ([self.wipAuditType isEqualToString:@"importWIP"]) {
            importVC.currentFile = self.JSONList[self.chosenJSONfile];
        }
        else if ([self.wipAuditType isEqualToString:@"localWIP"]){
            importVC.currentFile = self.localWIPList[self.chosenJSONfile];
        }
    }
    
    if( [segue.identifier isEqualToString:@"VerifyQuestions"])
    {
        //to recursively go through and find all verified questions!!
        VerifyQuestionsViewController *vq = [segue destinationViewController];
        
        vq.verifyQuestions = [self getVerifyQuestionsForAudit:self.audit];
    }
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
    self.numberOfUploadsLeft ++;
    //get file name from last string chunk
    NSArray *chunks = [dropboxPath componentsSeparatedByString: @"/"];
    
    NSString *fileName = [chunks objectAtIndex:[chunks count]-1];
    
    NSString * internalPath = [self setAttachPath:fileName];
    
    //[[self restClient2] uploadFile:fileName toPath:dropboxPath withParentRev:nil fromPath:internalPath];
    
    //using this deprecated method since it overwrites instead of renaming
    [[self restClient3] loadFile:dropboxPath intoPath:internalPath];
    
    return internalPath;
    
}

- (void)restClient:(DBRestClient*)client createdFolder:(DBMetadata*)folder{
    NSLog(@"Created Folder Path %@",folder.path);
    NSLog(@"Created Folder name %@",folder.filename);
    
    [self exportAudit];
    
}

// [error userInfo] contains the root and path
- (void)restClient:(DBRestClient*)client createFolderFailedWithError:(NSError*)error{
    NSLog(@"%@",error);
    //TODO: JSON LIST COUTN IS WRONG
    [self exportAudit];
}

-(void) exportAudit
{
    self.audit = [self formatAndExportAttachmentsAndImages:self.audit to:self.wipAuditPath];
    //all attachments and images are uploaded to Dbox now and locations in audit are reletive to Dbox
    
    NSDictionary *auditDictionary = [self.audit toDictionary];
    
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:auditDictionary options:NSJSONWritingPrettyPrinted error:&writeError];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  //  NSLog(@"JSON Output: %@", jsonString);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"MyFile.txt"];
    [jsonData writeToFile:appFile atomically:YES];
    
    //Using the user defaults to create the audit ID
    
          //  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
          //  NSString * auditID = [NSString stringWithFormat:@"%@.%@.%@", [defaults objectForKey:@"currentClient"], [defaults objectForKey:@"currentAudit"], [defaults objectForKey:@"currentUser"]];
         //   auditID = [auditID stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //dont need count since dropox will automatically append (x) to filename if it already exists
    //NSString* filename = [NSString stringWithFormat:@"%d-%@.json", countOfExistingAudits,auditID];
    
    NSString* filename = [NSString stringWithFormat:@"%@.json",self.audit.auditID];

    
    NSString *destDir = self.wipAuditPath;
    
    self.numberOfUploadsLeft++;
    
    [[self restClient] uploadFile:filename toPath:destDir
                    withParentRev:nil fromPath:appFile];
    
    
}

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata {
    
    self.numberOfUploadsLeft--;
    
    if (client == self->restClient){
        
        NSLog(@"File:%@ uploaded successfully to path: %@",destPath, metadata.path);

        
    }
    else if (client == self->restClient2){
        NSLog(@"File:%@ uploaded successfully to path: %@",destPath, metadata.path);

    }
    if (self.numberOfUploadsLeft == 0) {
        [self.spinner stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Export to Dropbox Successful" message:@"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    self.numberOfUploadsLeft--;
  if (client == self->restClient){
    
      NSLog(@"File upload failed with error - %@", error);

  }
    else if (client == self->restClient2){
        NSLog(@"File upload failed with error - %@", error);
        
    }
    
    if (self.numberOfUploadsLeft == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Export to Dropbox Failed" message:[NSString stringWithFormat: @"File upload failed with error - %@", error ] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [self.spinner stopAnimating];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(Audit*)formatAndExportAttachmentsAndImages:(Audit*)aud to:(NSString*)path
//exports all images and attachments to DBox and changes arrays in audit to hold Dbox locations
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
                        pathFrom = [self exportFile:pathFrom to:path];
                        [tempImageArr setObject:pathFrom atIndexedSubscript:m];
                    }
                    layQ.question.imageLocationArray = tempImageArr;
                    
                    NSMutableArray *tempAttachArr = [NSMutableArray arrayWithArray: layQ.question.attachmentsLocationArray];

                    for (int m = 0; m<tempAttachArr.count ; m++)
                    {
                        NSString *pathFrom = [tempAttachArr objectAtIndex:m];
                        pathFrom = [self exportFile:pathFrom to:path];
                        [tempAttachArr setObject:pathFrom atIndexedSubscript:m];
                    }
                    layQ.question.attachmentsLocationArray = tempAttachArr;
                    
                    NSMutableArray *tempDrawnLocs = [NSMutableArray arrayWithArray: layQ.question.drawnNotes];
                    
                    for (int m = 0; m<tempDrawnLocs.count ; m++)
                    {
                        NSString *pathFrom = [tempDrawnLocs objectAtIndex:m];
                        pathFrom = [self exportFile:pathFrom to:path];
                        [tempDrawnLocs setObject:pathFrom atIndexedSubscript:m];
                    }
                    layQ.question.drawnNotes = tempDrawnLocs;
                    
                }//sublayer loop
    
                //need to go through main question as well
                NSMutableArray *tempImageArr = [NSMutableArray arrayWithArray: question.imageLocationArray];
                
                for (int m = 0; m<tempImageArr.count ; m++)
                {
                    NSString *pathFrom = [tempImageArr objectAtIndex:m];
                    pathFrom = [self exportFile:pathFrom to:path];
                    [tempImageArr setObject:pathFrom atIndexedSubscript:m];
                }
                question.imageLocationArray = tempImageArr;
                
                NSMutableArray *tempAttachArr = [NSMutableArray arrayWithArray:question.attachmentsLocationArray];
                
                for (int m = 0; m<tempAttachArr.count ; m++)
                {
                    NSString *pathFrom = [tempAttachArr objectAtIndex:m];
                    pathFrom = [self exportFile:pathFrom to:path];
                    [tempAttachArr setObject:pathFrom atIndexedSubscript:m];
                }
                question.attachmentsLocationArray = tempAttachArr;
                
                NSMutableArray *drawnLoc = [NSMutableArray arrayWithArray:question.drawnNotes];
                
                for (int m = 0; m<drawnLoc.count ; m++)
                {
                    NSString *pathFrom = [drawnLoc objectAtIndex:m];
                    pathFrom = [self exportFile:pathFrom to:path];
                    [drawnLoc setObject:pathFrom atIndexedSubscript:m];
                }
                question.drawnNotes = drawnLoc;
            }//question loop
        }
    }
    return aud;
}

-(NSString*)exportFile:(NSString*)internalPath to:(NSString*)dropboxPath// withFile:(NSString*)fileName
{
    self.numberOfUploadsLeft ++;
    //get file name from last string chunk
    NSArray *chunks = [internalPath componentsSeparatedByString: @"/"];

    NSString *fileName = [chunks objectAtIndex:[chunks count]-1];
    
    //[[self restClient2] uploadFile:fileName toPath:dropboxPath withParentRev:nil fromPath:internalPath];
    
   //using this deprecated method since it overwrites instead of renaming
    [[self restClient2]uploadFile:fileName toPath:dropboxPath fromPath:internalPath];
    
    fileName = [dropboxPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    
    return fileName;
    
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
