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
#import "ClientFolder.h"

@interface ClientViewController ()<DBRestClientDelegate>


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
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    
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
    ClientFolder *client = [self.clients objectAtIndex:indexPath.row];
    
    nameLabel.text = client.clientName;
    
    [cell setBackgroundColor:[UIColor redColor]];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MainWindowPopOver * popContent = [self.storyboard instantiateViewControllerWithIdentifier:@"choices"];
    
    self.popOver= [[UIPopoverController alloc] initWithContentViewController:popContent];
   
    self.popOver.delegate = self;
    
    UICollectionViewCell * cell = [self.ClientCollectionView cellForItemAtIndexPath:indexPath];
    
    popContent.clientVC = self;
    
    [self.popOver presentPopoverFromRect:cell.frame inView:self.ClientCollectionView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
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
                ClientFolder *folder = [[ClientFolder alloc]init];
                folder.folderPath = file.path;
                folder.contents = file.contents;
                folder.clientName = file.filename;
                NSLog(@"	%@", file.filename);
                [clientList addObject:folder];
            }
        }
        self.clients = clientList;
        [self.ClientCollectionView reloadData];
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




@end
