//
//  ClientViewController.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ClientViewController.h"
#import "MainWindowPopOver.h"
#import <DropboxSDK/DropboxSDK.h>

#import "Folder.h"
#import "AuditSelectionViewController.h"
#import "ListOfWIPViewController.h"
#import "ListOfCompletedViewController.h"

@interface ClientViewController ()<DBRestClientDelegate>

@property int chosenClient;

@end

@implementation ClientViewController


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
    
    [self.spinner startAnimating];
    
    [[self restClient] loadMetadata:@"/"];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Collection View methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.clients count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ClientCell";
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel * nameLabel = (UILabel *)[cell viewWithTag:1];
    Folder *client = [self.clients objectAtIndex:indexPath.row];
    
    nameLabel.text = client.name;
    
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MainWindowPopOver * popContent = [self.storyboard instantiateViewControllerWithIdentifier:@"auditChoices"];
    
    self.clientPopOver= [[UIPopoverController alloc] initWithContentViewController:popContent];
   
    self.clientPopOver.delegate = self;
    
    UICollectionViewCell * cell = [self.ClientCollectionView cellForItemAtIndexPath:indexPath];
    
    popContent.clientVC = self;
    
    [self.clientPopOver setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.85]];
//    [[[self.clientPopOver contentViewController] view] setAlpha:0];
    
    [self.clientPopOver presentPopoverFromRect:cell.frame inView:self.ClientCollectionView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    self.chosenClient = indexPath.row;
    
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
        NSMutableArray *clientList = [[NSMutableArray alloc]init];
        for (DBMetadata *file in metadata.contents) {
            if (file.isDirectory) {
                Folder *folder = [[Folder alloc]init];
                folder.folderPath = file.path;
                folder.contents = file.contents;
                folder.name = file.filename;
                NSLog(@"	%@", file.filename);
                [clientList addObject:folder];
            }
        }
        self.clients = clientList;
        [self.ClientCollectionView reloadData];
        [self.spinner stopAnimating];
    }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}

#pragma mark Audit Type methods

-(void)goToChoice
{
    switch (self.auditType) {
        case 0:
            [self performSegueWithIdentifier:@"NewAuditChoice" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"WIPAuditChoice" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"CompletedAuditChoice" sender:self];
            break;
            
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"NewAuditChoice"]) {
        
        // Get destination view
        AuditSelectionViewController * newAuditVC = [segue destinationViewController];
        
        // Pass the information to your destination view
        Folder *folder = [self.clients objectAtIndex:self.chosenClient];
        
        [newAuditVC setDbNewFolderPath: [folder.folderPath stringByAppendingString:@"/New/"]];
        newAuditVC.companyName = folder.name;
        
    }
    
    if ([[segue identifier] isEqualToString:@"WIPAuditChoice"]) {
        
        // Get destination view
        ListOfWIPViewController * wipAuditVC = [segue destinationViewController];
        
        // Pass the information to your destination view
        Folder *folder = [self.clients objectAtIndex:self.chosenClient];
        
        [wipAuditVC setDbWIPFolderPath: [folder.folderPath stringByAppendingString:@"/WIP/"]];
        
    }
    
    if ([[segue identifier] isEqualToString:@"CompletedAuditChoice"]){
        
        // Get destination view
        ListOfCompletedViewController * completedAuditVC = [segue destinationViewController];
        
        // Pass the information to your destination view
        Folder *folder = [self.clients objectAtIndex:self.chosenClient];
        
        [completedAuditVC setDbCompletedFolderPath: [folder.folderPath stringByAppendingString:@"/Completed/"]];
    }
}



@end
