//
//  AuditSelectionViewController.m
//  DNV
//
//  Created by USI on 1/7/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "AuditSelectionViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "Folder.h"
#import "ElementSubElementViewController.h"
#import "Flurry.h"

@interface AuditSelectionViewController ()<DBRestClientDelegate>

@property (nonatomic) NSString *chosenAuditPath;

@end


@implementation AuditSelectionViewController

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
    
    self.companyNameLbl.text = self.companyName;
    
    NSLog(@"\n\nFolder Path recieved: %@", self.dbNewFolderPath);
    
    self.auditListTable.delegate = self;
    [self.spinner startAnimating];
    
    [[self restClient] loadMetadata:self.dbNewFolderPath];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.audits count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"AuditCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Folder *audit = [self.audits objectAtIndex:indexPath.row];
    
    cell.textLabel.text = audit.name;
    cell.textLabel.font = [UIFont systemFontOfSize:25.0];
//    cell.imageView.image = [UIImage imageNamed:@"check-mark-button.png"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Selected %@,",[self.audits objectAtIndex:indexPath.row]);
    
    Folder *temp =[self.audits objectAtIndex:indexPath.row];
    
    self.chosenAuditPath = temp.folderPath;
    
    NSLog(@"path to audit: %@", self.chosenAuditPath);
    
    [[self restClient2] loadMetadata:self.chosenAuditPath];
    [self.spinner startAnimating];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    ElementSubElementViewController * eleSubEleVC = [segue destinationViewController];
    eleSubEleVC.aud = self.audit;
    
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

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (client == self->restClient){
        if (metadata.isDirectory) {
            NSLog(@"Folder '%@' contains:", metadata.path);
            NSMutableArray *auditList = [[NSMutableArray alloc]init];
            for (DBMetadata *file in metadata.contents) {
                if (file.isDirectory) {
                    Folder *folder = [[Folder alloc]init];
                    folder.folderPath = file.path;
                    folder.contents = file.contents;
                    folder.name = file.filename;
                    NSLog(@"	%@", file.filename);
                    [auditList addObject:folder];
                }
            }
            self.audits = auditList;
        
            [self.auditListTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
        [self.spinner stopAnimating];
    }
    else if (client == self->restClient2){
        
        DBMetadata * JSONFile = metadata.contents[0];
        
        NSLog(@"metadata content: %@", metadata.contents[0]);
        NSLog(@"JSONFile: %@", JSONFile.filename);

        [self loadDropboxFile:JSONFile.filename];
    }

}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
    [self.spinner stopAnimating];
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath
       contentType:(NSString*)contentType metadata:(DBMetadata*)metadata {
    
    NSLog(@"File loaded into path: %@", localPath);
    [self getAudit];
    [self.spinner stopAnimating];
    
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    NSLog(@"There was an error loading the file - %@", error);
    [self.spinner stopAnimating];
}

#pragma mark file selection methods

-(void)loadDropboxFile:(NSString *)file{
    
    NSString *filename = [self.chosenAuditPath stringByAppendingPathComponent:file];
    
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
        
        //checking for correct audit
        
        //store current user in NSUSERDEFAULTS
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.audit.name forKey:@"currentAudit"];
        [defaults synchronize];
        
        //Just a DB test
        //Using the user defaults to create the audit ID
        self.audit.auditID = [NSString stringWithFormat:@"%@.%@.%@", [defaults objectForKey:@"currentClient"], [defaults objectForKey:@"currentAudit"], [defaults objectForKey:@"currentUser"]];
        self.audit.auditID = [self.audit.auditID stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.audit.auditType = 1;
        
        self.dnvDBManager = [DNVDatabaseManagerClass getSharedInstance];
        
        if ([self.dnvDBManager saveAudit:self.audit])//returns true if a new audit is created
        {
            //new audit started
            NSString *curClient = [defaults objectForKey:@"currentClient"];
            NSString *curAudit = [defaults objectForKey:@"currentAudit"];
            
            NSDictionary *newAuditParams =
            [NSDictionary dictionaryWithObjectsAndKeys:
             curClient, @"Client",
             curAudit, @"Audit Name",
             nil];
            
            [Flurry logEvent:@"New Audit Started" withParameters:newAuditParams];
            self.audit = [self.dnvDBManager retrieveAudit:self.audit.auditID];
            [self performSegueWithIdentifier:@"goToNewElement" sender:self];
        }
        else{
            
            UIAlertView * auditAlert = [[UIAlertView alloc] initWithTitle: @"Audit Save Options" message: @"An audit with this ID already exist in the DNV Database. Would you like to work with the currently saved audit, overwrite the saved audit, or keep the saved audit and start a new audit?" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Work On Current Audit", @"Overwrite Audit", @"Keep Both Audits", nil];
            
            [auditAlert show];
        }
        
        
        
        
        
        NSLog(@"Audit Name: %@", self.audit.name);
        
      //  ElementSubElementViewController * eleSubEleVC = [segue destinationViewController];
        //eleSubEleVC.aud = self.audit;
        //end of DB test
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0)
    {} // cancel button
    
    if (buttonIndex == 1)
    {
        self.audit = [self.dnvDBManager retrieveAudit:self.audit.auditID];
        [self performSegueWithIdentifier:@"goToNewElement" sender:self];
    }
    
    if (buttonIndex == 2)
    {
        
        [self.dnvDBManager deleteAudit:self.audit.auditID];
        [self.dnvDBManager saveAudit:self.audit];
        
        UIAlertView * overwriteNotice = [[UIAlertView alloc] initWithTitle:@"Audit Overwritten" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [overwriteNotice show];
        
        self.audit = [self.dnvDBManager retrieveAudit:self.audit.auditID];
        [self performSegueWithIdentifier:@"goToNewElement" sender:self];
        
    }
    
    if (buttonIndex == 3) {
        
        NSMutableArray * allAudits = [[NSMutableArray alloc]initWithArray:[self.dnvDBManager retrieveAllAuditIDsOfType:1 forAuditName:self.audit.name]];
        NSArray * tempArray = [self.dnvDBManager retrieveAllAuditIDsOfType:2 forAuditName:self.audit.name];
        
        [allAudits addObjectsFromArray:tempArray];
        
        self.audit.auditID = [NSString stringWithFormat:@"%@%d",self.audit.auditID,allAudits.count];
        [self.dnvDBManager saveAudit:self.audit];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //new audit started
        NSString *curClient = [defaults objectForKey:@"currentClient"];
        NSString *curAudit = [defaults objectForKey:@"currentAudit"];
        
        NSDictionary *newAuditParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         curClient, @"Client",
         curAudit, @"Audit Name",
         nil];
        
        [Flurry logEvent:@"New Audit Started" withParameters:newAuditParams];
        
        UIAlertView * keptBothNotice = [[UIAlertView alloc] initWithTitle:@"Saved Audit" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [keptBothNotice show];
        
        self.audit = [self.dnvDBManager retrieveAudit:self.audit.auditID];
        [self performSegueWithIdentifier:@"goToNewElement" sender:self];
    }
    
}

@end
