//
//  ImportMergeViewController.m
//  DNV
//
//  Created by USI on 1/14/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ImportMergeViewController.h"
#import <DropboxSDK/DropboxSDK.h>

#import "Audit.h"
#import "User.h"

@interface ImportMergeViewController ()<DBRestClientDelegate>
{
    int iSpotOfCurrFile;
    
    
}
@end

@implementation ImportMergeViewController

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
    
    NSLog(@"Current WIP: %@", self.currentFile);
    
    self.dnvDBManager = [DNVDatabaseManagerClass getSharedInstance];
    
    if ([self.currentFileType isEqualToString:@"importWIP"]) {
        iSpotOfCurrFile = (int)[self.jsonFiles indexOfObject:self.currentFile];
    }
    else if ([self.currentFileType isEqualToString:@"localWIP"]){
        iSpotOfCurrFile = (int)[self.localFiles indexOfObject:self.currentFile];
    }
    
    NSLog(@"Device Files: %d", self.localFiles.count);
    NSLog(@"Dropbox Files: %d", self.jsonFiles.count);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Collectionview methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(collectionView == self.localFilesCollection)
    {
        if ([self.currentFileType isEqualToString:@"localWIP"])
            return [self.localFiles count] - 1;
        else
            return [self.localFiles count];
    }
        
    else
    {
        if ([self.currentFileType isEqualToString:@"importWIP"])
            return [self.jsonFiles count] -1;
        else
            return [self.jsonFiles count];

    }

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView == self.localFilesCollection)
    {
        static NSString *identifier = @"localFileCell";
        
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        UILabel * fileLabel = (UILabel *)[cell viewWithTag:1];
        
        if ([self.currentFileType isEqualToString:@"localWIP"]){
            iSpotOfCurrFile = (int)[self.localFiles indexOfObject:self.currentFile];
            
            if( indexPath.row < iSpotOfCurrFile)
                fileLabel.text = self.localFiles[indexPath.row];
            else
                fileLabel.text = self.localFiles[indexPath.row+1];
        }
        else
            fileLabel.text = self.localFiles[indexPath.row];
        
        return cell;
        
    }


    static NSString *identifier = @"JSONFileCell";
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel * fileLabel = (UILabel *)[cell viewWithTag:1];
    
    if ([self.currentFileType isEqualToString:@"importWIP"]){
        iSpotOfCurrFile = (int)[self.jsonFiles indexOfObject:self.currentFile];
        
        if( indexPath.row < iSpotOfCurrFile)
            fileLabel.text = self.jsonFiles[indexPath.row];
        else
            fileLabel.text = self.jsonFiles[indexPath.row+1];
    }
    else
        fileLabel.text = self.jsonFiles[indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView == self.localFilesCollection)
    {
        if ([self.currentFileType isEqualToString:@"localWIP"]){
            
            if( indexPath.row < iSpotOfCurrFile)
                self.mergingAudit = [self.dnvDBManager retrieveAudit:self.localFiles[indexPath.row]];
            else
                self.mergingAudit = [self.dnvDBManager retrieveAudit:self.localFiles[indexPath.row+1]];
        }
        else
            self.mergingAudit = [self.dnvDBManager retrieveAudit:self.localFiles[indexPath.row]];
        
        UIAlertView * mergeAlert = [[UIAlertView alloc] initWithTitle: @"Merge Files" message: @"Are you sure you want to merge the selected file with the current WIP audit?" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
        [mergeAlert show];
        
        return;
    }
    
    if ([self.currentFileType isEqualToString:@"importWIP"]){
        
        if( indexPath.row < iSpotOfCurrFile)
            [self loadDropboxFile:self.jsonFiles[indexPath.row]];
        else
            [self loadDropboxFile:self.jsonFiles[indexPath.row+1]];
    }
    else
        [self loadDropboxFile:self.jsonFiles[indexPath.row]];
}

#pragma mark Alertview methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        //Code for Cancel button
    }
    if (buttonIndex == 1)
    {
        //Code for download button
        NSArray * auditIDs = [self.dnvDBManager retrieveAllAuditIDsOfType:1 forAuditName:self.currentAudit.name];
        
        NSArray * currentAuditIDChunks = [self.currentAudit.auditID componentsSeparatedByString:@"."];
        NSArray * mergeAuditIDChunks = [self.mergingAudit.auditID componentsSeparatedByString:@"."];
        
        User * currentUser = [self.dnvDBManager retrieveUser:currentAuditIDChunks[2]];
        User * mergeUser = [self.dnvDBManager retrieveUser:mergeAuditIDChunks[2]];
        
        Audit * mergedAudit = [self.currentAudit mergeAudit:self.currentAudit ofUserRank:currentUser.rank with:self.mergingAudit ofRank:mergeUser.rank];
        
        mergedAudit.auditID = [NSString stringWithFormat:@"%@.%d",self.currentAudit.auditID, auditIDs.count +1];
        
        [self.dnvDBManager saveAudit:mergedAudit];
        
        UIAlertView * mergeNotice = [[UIAlertView alloc] initWithTitle:@"Merge Complete" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [mergeNotice show];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark Dropbox methods

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
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

#pragma mark file selection methods

-(void)loadDropboxFile:(NSString *)file{
    
    NSString * path = self.wipPath;
 
    NSString *filename = [path stringByAppendingPathComponent:file];
    
    NSLog(@"Filename: %@", filename);
    
    _directoryPath = [self setFilePath];
    
    [[self restClient] loadFile:filename intoPath:_directoryPath];
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
        self.mergingAudit = [[Audit alloc]initWithAudit:theAudit];
        
//        [self.dnvDBManager saveAudit:self.mergingAudit];
//        
//        self.mergingAudit = [self.dnvDBManager retrieveAudit:self.mergingAudit.auditID];
        
        UIAlertView * mergeAlert = [[UIAlertView alloc] initWithTitle: @"Merge Files" message: @"Are you sure you want to merge the selected file with the current WIP audit?" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
        [mergeAlert show];
//
//        NSLog(@"Audit Name: %@", self.audit.name);
        //end of DB test
        
    }
}


@end
