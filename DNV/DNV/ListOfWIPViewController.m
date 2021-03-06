//
//  ListOfWIPViewController.m
//  DNV
//
//  Created by USI on 1/9/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ListOfWIPViewController.h"
#import <DropboxSDK/DropboxSDK.h>

#import "WIPAuditFilesViewController.h"

#import "Folder.h"

@interface ListOfWIPViewController ()<DBRestClientDelegate>

@property int chosenWIP;
@property NSString * WIPType;

@end

@implementation ListOfWIPViewController

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
    
    
   
}
-(void)viewWillAppear:(BOOL)animated
{
    self.sectionHeaders = [[NSArray alloc]initWithObjects:@"On Device",@"From Dropbox", nil];
    
    NSLog(@"\n\nFolder Path recieved: %@", self.ogdbWIPFolderPath);
    
    self.wipAuditTable.delegate = self;
    
    //local WIP
    self.dnvDBManager = [DNVDatabaseManagerClass getSharedInstance];
    self.localWips = [self.dnvDBManager retrieveDistinctAuditNamesForClientOfType:1];
    
    //Checks for internect connectivity when the View Appears
    if ([self.navigationController.navigationBar.backgroundColor isEqual:[UIColor greenColor]]){
        
        if (self.ogdbWIPFolderPath != nil) {
            [[self restClient] loadMetadata:self.ogdbWIPFolderPath];
            [self.spinner startAnimating];
        }
    }
    else{
        [self.spinner stopAnimating];
    }
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
        numberOfRows = (int)[self.localWips count];
    }
    else {
        numberOfRows = (int)[self.wips count];
    }
    
    return numberOfRows;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"WIPCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if(indexPath.section == 0)
        cell.textLabel.text = [self.localWips objectAtIndex:indexPath.row];
    else if(indexPath.section == 1){
        Folder * wip = [self.wips objectAtIndex:indexPath.row];
        
        cell.textLabel.text = wip.name;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:25.0];
    //    cell.imageView.image = [UIImage imageNamed:@"check-mark-button.png"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults *nsDefaults = [NSUserDefaults standardUserDefaults];
    
    if (indexPath.section == 0) {
        self.WIPType = @"localWIP";
        [nsDefaults setObject:self.localWips[indexPath.row] forKey:@"currentAudit"];
        [nsDefaults synchronize];
        
    }
    else{
        self.WIPType = @"importWIP";
        Folder * wip = [self.wips objectAtIndex:indexPath.row];
        
        [nsDefaults setObject:wip.name forKey:@"currentAudit"];
        [nsDefaults synchronize];
    }
    
    self.chosenWIP = indexPath.row;
    
    [self performSegueWithIdentifier:@"listWIPAuditFiles" sender:self];
}

#pragma mark WIP selection methods


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
        // Get destination view
        
        // Pass the information to your destination view
    WIPAuditFilesViewController * wipAuditFileVC = [segue destinationViewController];
    
    if ([self.WIPType isEqualToString:@"localWIP"]){
        
        wipAuditFileVC.localWIPName = [self.localWips objectAtIndex:self.chosenWIP];
        
        
    }
    
    if ([self.WIPType isEqualToString:@"importWIP"]){
    
        Folder *temp =[self.wips objectAtIndex:self.chosenWIP];
    
        self.dbWIPFolderPath = temp.folderPath;
        
        wipAuditFileVC.localWIPName = temp.name;

    }
    
    NSLog(@"WIP Audit Path: %@",self.ogdbWIPFolderPath);
    
    if (self.wips.count >0) {
        wipAuditFileVC.hasDropboxFiles = true;
    }
    else
        wipAuditFileVC.hasDropboxFiles = false;
    
    [wipAuditFileVC setWipAuditPath: self.ogdbWIPFolderPath];
    wipAuditFileVC.wipAuditType = _WIPType;

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
        NSMutableArray *wipList = [[NSMutableArray alloc]init];
        for (DBMetadata *file in metadata.contents) {
            if (file.isDirectory) {
                Folder *folder = [[Folder alloc]init];
                folder.folderPath = file.path;
                folder.contents = file.contents;
                folder.name = file.filename;
                NSLog(@"	%@", file.filename);
                [wipList addObject:folder];
            }
        }
        
        self.wips = wipList;
        [self.wipAuditTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
    [self.spinner stopAnimating];
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
    
    UIAlertView * dropboxLoadMetadataErrorAlert = [[UIAlertView alloc] initWithTitle:@"Loading Metadata From Dropbox Error" message:[NSString stringWithFormat:@"There was an error loading metadata. Receiving the following error message from Dropbox: \n%@", error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [dropboxLoadMetadataErrorAlert show];
}


@end
