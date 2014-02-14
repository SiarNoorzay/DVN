//
//  AttachmentsPopOverViewController.m
//  DNV
//
//  Created by Jaime Martinez on 2/12/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "AttachmentsPopOverViewController.h"
#import "AnswersViewController.h"

@interface AttachmentsPopOverViewController ()
{
    int iTableSelected;
    int iSelectedRow;
    NSString *chosenFile;
    
    int iRemoveItemAtThisPosition;
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
    
    NSString *dataPath1 = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%d", self.question.questionID]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath1 withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    [self.tblLocalAttachments reloadData];
    
    [self.btnAttachFile setEnabled:false];
    [self.btnDeleteSelected setEnabled:false];
    [self.btnSeeSelected setEnabled:false];
    
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
        NSString *fullPath =[self.question.attachmentsLocationArray objectAtIndex:indexPath.row];
        NSString *dataPath1 = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%d", self.question.questionID]];
        NSRange spotOfFullPath = [fullPath rangeOfString:dataPath1];
        [cell.textLabel setText:[fullPath substringFromIndex:spotOfFullPath.length+1]];
        
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
        chosenFile = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];

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
    if(iTableSelected == 0)
    {
        NSString *dataPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Attachments"];
        NSError *error = [NSError new];
        
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",dataPath, chosenFile] error: &error];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *arrayFiles = [fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@",dataPath] error:&error];
        
        self.arrLocalFiles = [[NSMutableArray alloc]initWithArray:arrayFiles];
        
        [self.tblLocalAttachments reloadData];
    }
    else
    {
        NSString *dataPath1 = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%d", self.question.questionID]];
        
        NSError *error = [NSError new];
        
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",dataPath1, chosenFile] error: &error];
        
        NSMutableArray *toRemove = [[NSMutableArray alloc]initWithArray:self.question.attachmentsLocationArray];
        [toRemove removeObjectAtIndex:iSelectedRow];
        self.question.attachmentsLocationArray = [[NSArray alloc]initWithArray:toRemove];
        [self.tblQuestionAttachments reloadData];
    }
}

- (IBAction)btnSeeSelected:(id)sender
{
    ((AnswersViewController*)self.myAnswersVC).chosenFile = chosenFile;
    [((AnswersViewController*)self.myAnswersVC) showAFile];
    
//    @try
//    {
//        QLPreviewController * preview = [[QLPreviewController alloc] init];
//        preview.dataSource = self;
//        [self presentViewController:preview animated:YES completion:nil];
//    }
//    @catch (NSException *exception)
//    {
//        //nslog(@"Exception caught: %@", exception);
//    }
}

- (IBAction)btnAttachFile:(id)sender
{
     NSString *toCompare = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%d", self.question.questionID]];
    toCompare = [NSString stringWithFormat:@"%@/%@", toCompare, [self.arrLocalFiles objectAtIndex:iSelectedRow]];
    
    if( [self.question.attachmentsLocationArray indexOfObject:toCompare] != NSNotFound )
    {
        iRemoveItemAtThisPosition = [self.question.attachmentsLocationArray indexOfObject:toCompare];
        
        UIAlertView *containedAlready = [[UIAlertView alloc] initWithTitle:@"Duplicate!" message:@"File of that name already attached:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Keep Original", @"Overwrite existing", @"Keep both", nil];
    
        [containedAlready show];
    }
    else
    {
        [self addFileToAttachmentsArrayandRemove:-1];
    }
}

-(void)addFileToAttachmentsArrayandRemove:(int)itemAt
{
    NSMutableArray *toAdd = [[NSMutableArray alloc]initWithArray:self.question.attachmentsLocationArray];
    
    NSString *dataPath1 = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%d", self.question.questionID]];
    
    if( itemAt > -1)
        [toAdd removeObjectAtIndex:itemAt];
    
    [toAdd addObject:[NSString stringWithFormat:@"%@/%@", dataPath1,[self.arrLocalFiles objectAtIndex:iSelectedRow]]];
    
    self.question.attachmentsLocationArray = [[NSArray alloc]initWithArray:toAdd];
    

    NSData *currData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.question.attachmentsLocationArray lastObject]]];
    
     NSFileManager *fileManager = [NSFileManager new];
    [fileManager createFileAtPath:[NSString stringWithFormat:@"%@/%@", dataPath1, [self.arrLocalFiles objectAtIndex:iSelectedRow]] contents:currData attributes:nil];
    
    
    [self.tblQuestionAttachments reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //keep original, do nothing
    if (buttonIndex == 1)   {}

    //over write existing
    if (buttonIndex == 2)
        [self addFileToAttachmentsArrayandRemove:iRemoveItemAtThisPosition];
    
    //keep both
    if (buttonIndex == 3)
        [self addFileToAttachmentsArrayandRemove:-1];
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
