//
//  ReportDocViewController.h
//  DNV
//
//  Created by USI on 1/22/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Audit.h"
#import "DNVDatabaseManagerClass.h"
#import <MessageUI/MessageUI.h>


@class DBRestClient;


@interface ReportDocViewController : UIViewController<UIScrollViewDelegate,MFMailComposeViewControllerDelegate>
{
    DBRestClient * restClient;
    DBRestClient * restClient2;
    
}
@property (strong, nonatomic) DNVDatabaseManagerClass * dnvDBManager;

@property (strong, nonatomic) Audit *audit;
@property (strong,atomic) NSMutableArray *allSublayeredQuestions;

+(ReportDocViewController*)sharedReportDocViewController;

@property(strong,nonatomic) NSString *pdfSavedAt;
@property (strong,nonatomic) NSMutableData *pdfData;

@property(strong,nonatomic) NSString *completeAuditPath;

@property (strong, nonatomic) IBOutlet UIScrollView *finalPFDView;

@property (strong, nonatomic) NSMutableArray *viewArray;
- (IBAction)emailButtonPushed:(id)sender;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


- (IBAction)submitToDBoxPushed:(id)sender;

@end
