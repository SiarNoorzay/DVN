//
//  AttachmentsPopOverViewController.m
//  DNV
//
//  Created by Jaime Martinez on 2/12/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "AttachmentsPopOverViewController.h"

@interface AttachmentsPopOverViewController ()
{
    int iTableSelected;
    int iSelectedRow;
    NSString *chosenFile;
}
@end

@implementation AttachmentsPopOverViewController

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
    
    NSString *dataPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Attachments"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *arrayFiles = [fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@",dataPath] error:&error];
    
    self.arrLocalFiles = [NSMutableArray new];
    [self.arrLocalFiles addObjectsFromArray:arrayFiles];
    
    if( self.question.attachmentsLocationArray == nil)
    {
        self.question.attachmentsLocationArray = [NSArray new];
    }
    
    [self.tblLocalAttachments reloadData];
    
    [self.btnAttachFile setEnabled:false];
    [self.btnDeleteSelected setEnabled:false];
    [self.btnSeeSelected setEnabled:false];
    
    //todo add array to attachmentsarray of question, at position 0, if and only if that position does not contain an array already... inform cliff and siar to handle that accordingly
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Begin TableView Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( tableView == self.tblLocalAttachments)
        return [self.arrLocalFiles count];
    else
        return [ self.question.attachmentsLocationArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if( tableView == self.tblLocalAttachments)
    {
        [cell.textLabel setText:[self.arrLocalFiles objectAtIndex:indexPath.row]];
        
        return cell;
    }
    else
    {
        [cell.textLabel setText:[self.question.attachmentsLocationArray objectAtIndex:indexPath.row]];
        
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( tableView == self.tblLocalAttachments)
    {
        iTableSelected = 0;
        chosenFile = [self.arrLocalFiles objectAtIndex:indexPath.row];
        
        [self.btnAttachFile setEnabled:true];
        
        [self.tblQuestionAttachments deselectRowAtIndexPath:[self.tblQuestionAttachments indexPathForSelectedRow] animated:YES];
    }
    else
    {
        iTableSelected = 1;
        chosenFile = [self.question.attachmentsLocationArray objectAtIndex:indexPath.row];
        
        [self.btnAttachFile setEnabled:false];
        
        [self.tblLocalAttachments deselectRowAtIndexPath:[self.tblLocalAttachments indexPathForSelectedRow] animated:YES];
    }
    
    iSelectedRow = indexPath.row;
    
    [self.btnDeleteSelected setEnabled:true];
    [self.btnSeeSelected setEnabled:true];
}
#pragma End TableView Methods

- (IBAction)btnDeleteSelected:(id)sender
{
    NSString *dataPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Attachments"];
    NSError *error = [NSError new];
    
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",dataPath, chosenFile] error: &error];
    
    if(iTableSelected == 0)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSArray *arrayFiles = [fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@",dataPath] error:&error];
        
        self.arrLocalFiles = [[NSMutableArray alloc]initWithArray:arrayFiles];
        
        [self.tblLocalAttachments reloadData];
    }
    else
    {
        NSMutableArray *toRemove = [[NSMutableArray alloc]initWithArray:self.question.attachmentsLocationArray];
        [toRemove removeObjectAtIndex:iSelectedRow];
        self.question.attachmentsLocationArray = [[NSArray alloc]initWithArray:toRemove];
        [self.tblQuestionAttachments reloadData];
    }
}

- (IBAction)btnSeeSelected:(id)sender
{
    //Present opened in file through QLPreviewController
    @try
    {
        QLPreviewController * preview = [[QLPreviewController alloc] init];
        preview.dataSource = self;
        [self presentViewController:preview animated:YES completion:nil];
    }
    @catch (NSException *exception)
    {
        //nslog(@"Exception caught: %@", exception);
    }
}

- (IBAction)btnAttachFile:(id)sender
{
    NSMutableArray *toAdd = [[NSMutableArray alloc]initWithArray:self.question.attachmentsLocationArray];
    [toAdd addObject:[self.arrLocalFiles objectAtIndex:iSelectedRow]];
    self.question.attachmentsLocationArray = [[NSArray alloc]initWithArray:toAdd];
    
    [self.tblQuestionAttachments reloadData];
}

//// Quick Look methods, delegates and data sources...
#pragma mark QLPreviewControllerDelegate methods
- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item {
	
	return YES;
}


#pragma mark QLPreviewControllerDataSource methods
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller{
    return 1;
}

- (id <QLPreviewItem>) previewController: (QLPreviewController *) controller previewItemAtIndex: (NSInteger) index
{
    NSString *dataPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Attachments"];
    
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",dataPath, chosenFile]];
}
////

@end
