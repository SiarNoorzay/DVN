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

@interface WIPAuditFilesViewController ()<DBRestClientDelegate>

@property int chosenJSONfile;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[self restClient] loadMetadata:self.wipAuditPath];
    [self.spinner startAnimating];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.JSONList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"WIPAuditCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.JSONList[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WIPChoicePopOver * wipPopContent = [self.storyboard instantiateViewControllerWithIdentifier:@"wipChoices"];
    
    self.wipPopOver = [[UIPopoverController alloc] initWithContentViewController:wipPopContent];
    
    self.wipPopOver.delegate = self;
    
    UITableViewCell * cell = [self.wipJSONFileTable cellForRowAtIndexPath:indexPath];
    
    wipPopContent.WIPAuditFilesVC = self;
    
    [self.wipPopOver presentPopoverFromRect:cell.frame inView:self.wipJSONFileTable permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
    
    self.chosenJSONfile = indexPath.row;
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
        self.JSONList = [[NSMutableArray alloc]init];
        for (DBMetadata * file in metadata.contents) {
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

#pragma mark WIP selection methods

-(void)goToWIPChoice
{
    switch (self.wipJSONChoice) {
        case 0:
            [self performSegueWithIdentifier:@"ContinueAudit" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"VerifyQuestions" sender:self];
            break;
        case 2:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Dropbox Export Complete" message: @"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
            break;
        case 3:
            [self performSegueWithIdentifier:@"ImportMerge" sender:self];
            break;
            
        default:
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"ContinueAudit"]) {
        ElementSubElementViewController * eleSubEleVC = [segue destinationViewController];
        
        [eleSubEleVC setAuditPath: [self.wipAuditPath stringByAppendingPathComponent:self.JSONList[self.chosenJSONfile]]];
        eleSubEleVC.audType = self.wipAuditType;
        
    }
    
//    if ([segue.identifier isEqualToString:@"VerifyQuestions"]){
//        
//        
//    }
    
    if ([segue.identifier isEqualToString:@"ImportMerge"]){
        
        ImportMergeViewController * importVC = [segue destinationViewController];
        
        importVC.jsonFiles = self.JSONList;
        importVC.currentFile = self.JSONList[self.chosenJSONfile];
    }
    
//    NSIndexPath *indexPath = self.subElementTable.indexPathForSelectedRow;
//    
//    QuestionsViewController * questionsVC = [segue destinationViewController];
//    
//    self.subEle = [[SubElements alloc]initWithSubElement:self.listOfSubElements[indexPath.row]];
//    questionsVC.questionArray = self.subEle.Questions;
}


@end
