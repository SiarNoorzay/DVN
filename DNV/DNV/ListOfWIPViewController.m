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
    
    self.sectionHeaders = [[NSArray alloc]initWithObjects:@"On Device",@"From Dropbox", nil];
    
    NSLog(@"\n\nFolder Path recieved: %@", self.dbWIPFolderPath);
    
    self.wipAuditTable.delegate = self;
    
    [[self restClient] loadMetadata:self.dbWIPFolderPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.sectionHeaders[section];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int numberOfRows;
    
    if (section == 0){
        numberOfRows = 1;
    }
    else {
        numberOfRows = [self.wips count];
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
        cell.textLabel.text = @"I'm Local";
    else if(indexPath.section == 1){
        Folder * wip = [self.wips objectAtIndex:indexPath.row];
        
        cell.textLabel.text = wip.name;
    }
    //    cell.imageView.image = [UIImage imageNamed:@"check-mark-button.png"];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        self.WIPType = @"localWIP";
    }
    else{
        self.WIPType = @"importWIP";
    }
    
    self.chosenWIP = indexPath.row;
    
    [self performSegueWithIdentifier:@"listWIPAuditFiles" sender:self];
}

#pragma mark WIP selection methods


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
        // Get destination view
        
        // Pass the information to your destination view
//    NSLog(@"Selected %@,",[self.wips objectAtIndex:self.chosenWIP]);
    
    Folder *temp =[self.wips objectAtIndex:self.chosenWIP];
    
    
    self.dbWIPFolderPath = temp.folderPath;

    WIPAuditFilesViewController * wipAuditFileVC = [segue destinationViewController];
    [wipAuditFileVC setWipAuditPath: self.dbWIPFolderPath];
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
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}


@end
