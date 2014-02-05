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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = self.auditListTable.indexPathForSelectedRow;
    
    //store current user in NSUSERDEFAULTS
    NSUserDefaults *nsDefaults = [NSUserDefaults standardUserDefaults];
    [nsDefaults setObject:[[self.audits objectAtIndex:indexPath.row] name] forKey:@"currentAudit"];
    [nsDefaults synchronize];
    
    NSLog(@"Selected %@,",[self.audits objectAtIndex:indexPath.row]);
    
    Folder *temp =[self.audits objectAtIndex:indexPath.row];
    
    self.chosenAuditPath = temp.folderPath;
    
    ElementSubElementViewController * eleSubEleVC = [segue destinationViewController];
    [eleSubEleVC setAuditPath: self.chosenAuditPath];
    eleSubEleVC.audType = @"New";
    
    NSLog(@"path to audit: %@", self.chosenAuditPath);
    
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
        
     //   [self.auditListTable reloadData];
        [self.auditListTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
    [self.spinner stopAnimating];

}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}


@end
