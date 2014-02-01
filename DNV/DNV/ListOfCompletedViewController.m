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

@interface ListOfCompletedViewController ()<DBRestClientDelegate>

@property int chosenCompleted;
@property NSString * completedType;

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
    
    //local WIP
    self.dnvDBManager = [DNVDatabaseManagerClass getSharedInstance];
    self.localCompleted = [self.dnvDBManager retrieveDistinctAuditNamesForClientOfType:2];
    
    [[self restClient] loadMetadata:self.dbCompletedFolderPath];
    
    [self.spinner startAnimating];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    
    if (indexPath.section == 0) {
        self.completedType = @"localCompleted";
    }
    else{
        self.completedType = @"importCompleted";
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


- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
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

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
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
        default:
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = self.completedAuditTable.indexPathForSelectedRow;
    
    self.audit = [Audit new];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
 //   [defaults setObject:[self.localCompleted objectAtIndex:indexPath.row] forKey:@"currentAudit"];
    [defaults synchronize];
    
    self.audit.auditID = [NSString stringWithFormat:@"%@.%@.%@", [defaults objectForKey:@"currentClient"], [defaults objectForKey:@"currentAudit"], [defaults objectForKey:@"currentUser"]];
    self.audit.auditID = [self.audit.auditID stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([segue.identifier isEqualToString:@"EditClient"]) {
        
        EditClientViewController * editClientVC = [segue destinationViewController];
        
        if ([self.completedType isEqualToString:@"localCompleted"]) {
            
            
            
            self.audit = [self.dnvDBManager retrieveAudit:self.audit.auditID];
            
            editClientVC.client = self.audit.client;
            editClientVC.report = self.audit.report;
            editClientVC.auditID = self.audit.auditID;
        }
    }
    
    if ([segue.identifier isEqualToString:@"EditQuestions"]){
        
        ElementSubElementViewController * eleSubEleVC = [segue destinationViewController];
        
        if ([self.completedType isEqualToString:@"importCompleted"]){
        
            NSLog(@"Selected %@,",[self.completed objectAtIndex:indexPath.row]);
    
            Folder *temp =[self.completed objectAtIndex:indexPath.row];
    
            //    NSLog(@"Path of Audit: %@", temp.folderPath);
            
            [eleSubEleVC setAuditPath: temp.folderPath];
        }
    
        eleSubEleVC.audType = @"Completed";
    }
}

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
    }
}

@end
