//
//  ImportMergeViewController.m
//  DNV
//
//  Created by USI on 1/14/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ImportMergeViewController.h"

@interface ImportMergeViewController ()
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
    
//    [self.jsonFileCollection reloadData];
    iSpotOfCurrFile = (int)[self.jsonFiles indexOfObject:self.currentFile];
    self.sectionHeaders = [[NSArray alloc]initWithObjects:@"On Device", @"On Dropbox", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Collectionview methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.sectionHeaders.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.jsonFiles count]-1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *identifier = @"JSONFileCell";
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel * fileLabel = (UILabel *)[cell viewWithTag:1];
    
    if( indexPath.row < iSpotOfCurrFile)
        fileLabel.text = self.jsonFiles[indexPath.row];
    else
        fileLabel.text = self.jsonFiles[indexPath.row+1];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertView * mergeAlert = [[UIAlertView alloc] initWithTitle: @"Merge Files" message: @"Are you sure you want to merge the selected file with the current WIP audit?" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
    [mergeAlert show];
    
    
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
        UIAlertView * mergeNotice = [[UIAlertView alloc] initWithTitle:@"Merge Complete" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [mergeNotice show];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
