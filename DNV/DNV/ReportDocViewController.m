//
//  ReportDocViewController.m
//  DNV
//
//  Created by USI on 1/22/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ReportDocViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "LayeredQuestion.h"
#import <DropboxSDK/DropboxSDK.h>
#import "Flurry.h"


@interface ReportDocViewController ()<DBRestClientDelegate>
@property int numberOfUploadsLeft;

@end

@implementation ReportDocViewController

static ReportDocViewController* _sharedReportDocViewController = nil;

+(ReportDocViewController*)sharedReportDocViewController
{
    @synchronized([ReportDocViewController class])
    {
        if (!_sharedReportDocViewController)
         _sharedReportDocViewController = [[self alloc] init];
        
        return _sharedReportDocViewController;
    }
    
    return nil;
}

- (id)init {
    if (self = [super init]) {
//        self.finalPFDView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,612,792)];
//        self.finalPFDView.showsVerticalScrollIndicator=YES;
//        self.finalPFDView.scrollEnabled=YES;
//        self.finalPFDView.userInteractionEnabled=YES;
//        self.finalPFDView.contentSize = CGSizeMake(612,0);
//        self.finalPFDView.delegate = self;
        
        self.viewArray = [[NSMutableArray alloc]initWithCapacity:10];
        
        for (NSInteger i = 0; i < 10; ++i)
        {
            [self.viewArray addObject:[NSNull null]];
        }

        
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *curClient = [defaults objectForKey:@"currentClient"];
    NSString *curAudit = [defaults objectForKey:@"currentAudit"];
    
    NSDictionary *completedAuditParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     curClient, @"Client",
     curAudit, @"Audit Name",
     nil];
    
    [Flurry logEvent:@"Audit Completed" withParameters:completedAuditParams];
}
- (void)viewDidLoad
{

    
    [self.spinner startAnimating];
    
    self.dnvDBManager = [DNVDatabaseManagerClass getSharedInstance];

    [self.dnvDBManager updateClient:self.audit.client];
    [self.dnvDBManager updateReport:self.audit.report];
    
    
    ReportDocViewController *reportDoc = [ReportDocViewController sharedReportDocViewController];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    
    NSString *theDate = [dateFormat stringFromDate:date];

    NSUserDefaults *nsDefaults = [NSUserDefaults standardUserDefaults];
    
    self.completeAuditPath = [NSString stringWithFormat:@"/%@/COMPLETED/%@ %@ %@/",[nsDefaults objectForKey:@"currentClient"], [nsDefaults objectForKey:@"currentAudit"],theDate,[nsDefaults objectForKey:@"currentUser"]];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGSize initial = self.finalPFDView.contentSize;
    initial.height = 10;
    initial.width = 612;
    self.finalPFDView.contentSize = initial;
    
    NSLog(@"Number of views in view array: %d",reportDoc.viewArray.count);
    
    for (UIView *view in reportDoc.viewArray) {
        [view setUserInteractionEnabled:NO];
        
        view.frame = CGRectMake(0, self.finalPFDView.contentSize.height, 612, view.frame.size.height);
//        CGRect rect = view.frame;
//        rect.origin.y = self.finalPFDView.frame.size.height;
//        view.frame = rect;
        
        CGSize size = self.finalPFDView.contentSize;
        size.height = size.height + view.frame.size.height;
        self.finalPFDView.contentSize = size;
        
        [self.finalPFDView addSubview:view];
    }
    
    
    self.pdfSavedAt = [self createPDFfromUIView:self.finalPFDView saveToDocumentsWithFileName:@"AuditReport.pdf"];
    
    [self.spinner stopAnimating];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString*)createPDFfromUIView:(UIScrollView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    //MultiPage
    NSMutableData *pdfData = [NSMutableData data];

    CGRect mediaBox = CGRectMake(aView.frame.origin.x, aView.frame.origin.y, aView.contentSize.width, aView.contentSize.height);
    CGSize pageSize = CGSizeMake(612, 792);
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    NSInteger currentPage = 0;
    BOOL done = NO;
    do {
        
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0.0, pageSize.width, pageSize.height), nil);
        CGContextTranslateCTM(pdfContext, 0, -(pageSize.height*currentPage));
        [aView.layer renderInContext:pdfContext];
        [self.finalPFDView setContentOffset:CGPointMake(0, (currentPage+1) * 792) animated:NO];
        if ((pageSize.height*(currentPage+1)) > mediaBox.size.height) done = YES;
        else currentPage++;
    } while (!done);
    UIGraphicsEndPDFContext();
    

    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
    
    self.pdfData = pdfData;
    [self.finalPFDView setContentOffset:CGPointMake(0, 0) animated:NO];

    return documentDirectoryFilename;
    
}


- (IBAction)emailButtonPushed:(id)sender {

    if ([MFMailComposeViewController canSendMail])
        
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        // Set the subject of email
        [picker setSubject:@"Audit Report"];
        [picker addAttachmentData:self.pdfData mimeType:@"application/pdf" fileName:@"AuditReport.pdf"];
        
        // Add email addresses
        // Notice three sections: "to" "cc" and "bcc"
        //[picker setToRecipients:[NSArray arrayWithObjects:emailString, nil]];
        
        //    [picker setCcRecipients:[NSArray arrayWithObject:@"CC MailID"]];
        //    [picker setBccRecipients:[NSArray arrayWithObject:@"BCC Mail ID"]];
        
        // Fill out the email body text
        
        // This is not an HTML formatted email
        
        // Show email view
        //        [self presentModalViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:Nil];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Email is not setup on this device" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
}

- (void) mailComposeController: (MFMailComposeViewController *) controller
           didFinishWithResult: (MFMailComposeResult) result
                         error: (NSError *) error {
    
    if(result == MFMailComposeResultSent){
        [self dismissViewControllerAnimated:YES completion:NULL];
        
    } else if (result == MFMailComposeResultCancelled) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)submitToDBoxPushed:(id)sender {
    
    [self.spinner startAnimating];
    [[self restClient] createFolder:self.completeAuditPath];
    

}
#pragma mark Dropbox methods

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}
- (DBRestClient*)restClient2 {
    if (restClient2 == nil) {
        restClient2 = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient2.delegate = self;
    }
    return restClient2;
}


- (void)restClient:(DBRestClient*)client createdFolder:(DBMetadata*)folder{
    NSLog(@"Created Folder Path %@",folder.path);
    NSLog(@"Created Folder name %@",folder.filename);
    
    [self exportAudit];
    
}

// [error userInfo] contains the root and path
- (void)restClient:(DBRestClient*)client createFolderFailedWithError:(NSError*)error{
    NSLog(@"%@",error);
    [self exportAudit];
}

-(void) exportAudit
{
    self.audit = [self formatAndExportAttachmentsAndImages:self.audit to:self.completeAuditPath];
    //all attachments and images are uploaded to Dbox now and locations in audit are reletive to Dbox
    
    NSDictionary *auditDictionary = [self.audit toDictionary];
    
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:auditDictionary options:NSJSONWritingPrettyPrinted error:&writeError];
    
    //NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //  NSLog(@"JSON Output: %@", jsonString);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"MyFile.txt"];
    [jsonData writeToFile:appFile atomically:YES];
    
    //Using the user defaults to create the audit ID
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * auditID = [NSString stringWithFormat:@"%@.%@.%@", [defaults objectForKey:@"currentClient"], [defaults objectForKey:@"currentAudit"], [defaults objectForKey:@"currentUser"]];
    auditID = [auditID stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString* filename = [NSString stringWithFormat:@"%@.json",auditID];
    
    
    NSString *destDir = self.completeAuditPath;
    
    self.numberOfUploadsLeft++;
    
    [[self restClient] uploadFile:filename toPath:destDir
                    withParentRev:nil fromPath:appFile];
    
    
    //TODO: Change pdf filename
    [[self restClient] uploadFile:@"AuditReport.pdf" toPath:destDir withParentRev:nil fromPath:self.pdfSavedAt];
    
    
}

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata {
    
    self.numberOfUploadsLeft--;
    
    NSLog(@"File:%@ uploaded successfully to path: %@",destPath, metadata.path);
    
    if (self.numberOfUploadsLeft == 0) {
        [self.spinner stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Export to Dropbox Successful" message:@"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
       // [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    self.numberOfUploadsLeft--;
    if (client == self->restClient){
        
        NSLog(@"File upload failed with error - %@", error);
        
    }
    else if (client == self->restClient2){
        NSLog(@"File upload failed with error - %@", error);
        
    }
    
    if (self.numberOfUploadsLeft == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Export to Dropbox Failed" message:[NSString stringWithFormat: @"File upload failed with error - %@", error ] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [self.spinner stopAnimating];
        
        //[self.navigationController popViewControllerAnimated:YES];
    }
}
-(Audit*)formatAndExportAttachmentsAndImages:(Audit*)aud to:(NSString*)path
//exports all images and attachments to DBox and changes arrays in audit to hold Dbox locations
{
    for (int i=0; i<aud.Elements.count; i++) {
        Elements *ele = [aud.Elements objectAtIndex:i];
        
        for (int j=0 ; j<ele.Subelements.count; j++) {
            SubElements *subEle = [ele.Subelements objectAtIndex:j];
            
            for (int k = 0; k<subEle.Questions.count; k++) {
                Questions *question = [subEle.Questions objectAtIndex:k];
                
                //loop through sublayers
                self.allSublayeredQuestions = [NSMutableArray new];
                int throwAway = [self getNumOfSubQuestionsAndSetAllSubsArray:question layerDepth:1];
                for (int l = 0; l<self.allSublayeredQuestions.count; l++) {
                    LayeredQuestion *layQ = [self.allSublayeredQuestions objectAtIndex:l];
                    NSMutableArray *tempImageArr = [NSMutableArray arrayWithArray: layQ.question.imageLocationArray];
                    
                    for (int m = 0; m<tempImageArr.count ; m++)
                    {
                        NSString *pathFrom = [tempImageArr objectAtIndex:m];
                        pathFrom = [self exportFile:pathFrom to:path];
                        [tempImageArr setObject:pathFrom atIndexedSubscript:m];
                    }
                    layQ.question.imageLocationArray = tempImageArr;
                    
                    NSMutableArray *tempAttachArr = [NSMutableArray arrayWithArray: layQ.question.attachmentsLocationArray];
                    
                    for (int m = 0; m<tempAttachArr.count ; m++)
                    {
                        NSString *pathFrom = [tempAttachArr objectAtIndex:m];
                        pathFrom = [self exportFile:pathFrom to:path];
                        [tempAttachArr setObject:pathFrom atIndexedSubscript:m];
                    }
                    layQ.question.attachmentsLocationArray = tempAttachArr;
                    
                    NSMutableArray *tempDrawnLocs = [NSMutableArray arrayWithArray: layQ.question.drawnNotes];
                    
                    for (int m = 0; m<tempDrawnLocs.count ; m++)
                    {
                        NSString *pathFrom = [tempDrawnLocs objectAtIndex:m];
                        pathFrom = [self exportFile:pathFrom to:path];
                        [tempDrawnLocs setObject:pathFrom atIndexedSubscript:m];
                    }
                    layQ.question.drawnNotes = tempDrawnLocs;
                    
                }//sublayer loop
                
                //need to go through main question as well
                NSMutableArray *tempImageArr = [NSMutableArray arrayWithArray: question.imageLocationArray];
                
                for (int m = 0; m<tempImageArr.count ; m++)
                {
                    NSString *pathFrom = [tempImageArr objectAtIndex:m];
                    pathFrom = [self exportFile:pathFrom to:path];
                    [tempImageArr setObject:pathFrom atIndexedSubscript:m];
                }
                question.imageLocationArray = tempImageArr;
                
                NSMutableArray *tempAttachArr = [NSMutableArray arrayWithArray:question.attachmentsLocationArray];
                
                for (int m = 0; m<tempAttachArr.count ; m++)
                {
                    NSString *pathFrom = [tempAttachArr objectAtIndex:m];
                    pathFrom = [self exportFile:pathFrom to:path];
                    [tempAttachArr setObject:pathFrom atIndexedSubscript:m];
                }
                question.attachmentsLocationArray = tempAttachArr;
                
                NSMutableArray *drawnLoc = [NSMutableArray arrayWithArray:question.drawnNotes];
                
                for (int m = 0; m<drawnLoc.count ; m++)
                {
                    NSString *pathFrom = [drawnLoc objectAtIndex:m];
                    pathFrom = [self exportFile:pathFrom to:path];
                    [drawnLoc setObject:pathFrom atIndexedSubscript:m];
                }
                question.drawnNotes = drawnLoc;
            }//question loop
        }
    }
    return aud;
}
-(NSString*)exportFile:(NSString*)internalPath to:(NSString*)dropboxPath
{
    self.numberOfUploadsLeft ++;
    //get file name from last string chunk
    NSArray *chunks = [internalPath componentsSeparatedByString: @"/"];
    
    NSString *fileName = [chunks objectAtIndex:[chunks count]-1];
    
    //[[self restClient2] uploadFile:fileName toPath:dropboxPath withParentRev:nil fromPath:internalPath];
    
    //using this deprecated method since it overwrites instead of renaming
    [[self restClient2]uploadFile:fileName toPath:dropboxPath fromPath:internalPath];
    
    fileName = [dropboxPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    
    return fileName;
    
}
-(int) getNumOfSubQuestionsAndSetAllSubsArray:(Questions *)question layerDepth:(int)depth
{
    int n = 1;
    for (int i = 0; i < [question.layeredQuesions count]; i++)
    {
        LayeredQuestion *tempObject = [LayeredQuestion new];
        
        tempObject.question = [question.layeredQuesions objectAtIndex:i];
        [self.allSublayeredQuestions addObject:tempObject];
        
        if( tempObject.question.layeredQuesions.count > 0)
            depth++;
        
        n += [self getNumOfSubQuestionsAndSetAllSubsArray:tempObject.question layerDepth:depth];
        
        tempObject.subIndexes = [NSMutableArray new];
        for( int j = 1; j <= tempObject.question.layeredQuesions.count; j++ )
        {
            
            [tempObject.subIndexes addObject:[NSNumber numberWithInt: j + [self.allSublayeredQuestions indexOfObject:tempObject] ] ];
        }
        
    }
    return n;
}
@end

