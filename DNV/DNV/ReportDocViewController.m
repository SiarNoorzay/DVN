//
//  ReportDocViewController.m
//  DNV
//
//  Created by USI on 1/22/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ReportDocViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface ReportDocViewController ()

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
    
}
- (void)viewDidLoad
{

    ReportDocViewController *reportDoc = [ReportDocViewController sharedReportDocViewController];
    
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createPDFPushed:(id)sender {
    
    [self createPDFfromUIView:self.finalPFDView saveToDocumentsWithFileName:@"AuditReport.pdf"];
    

}

-(void)createPDFfromUIView:(UIScrollView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
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
    
    
    
    
//    
//    // Creates a mutable data object for updating with binary data, like a byte array
//    
//    // Points the pdf converter to the mutable data object and to the UIView to be converted
//    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
//    UIGraphicsBeginPDFPage();
//    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
//    
//    
//    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
//    
//    [aView.layer renderInContext:pdfContext];
//    
//    // remove PDF rendering context
//    UIGraphicsEndPDFContext();
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
}
@end

