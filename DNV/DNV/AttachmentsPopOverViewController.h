//
//  AttachmentsPopOverViewController.h
//  DNV
//
//  Created by Jaime Martinez on 2/12/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Questions.h"

#import <QuickLook/QuickLook.h>

@interface AttachmentsPopOverViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblLocalAttachments;
@property (weak, nonatomic) IBOutlet UITableView *tblQuestionAttachments;

@property (strong, nonatomic) NSMutableArray *arrLocalFiles;

- (IBAction)btnDeleteSelected:(id)sender;
- (IBAction)btnSeeSelected:(id)sender;

- (IBAction)btnAttachFile:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAttachFile;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteSelected;
@property (weak, nonatomic) IBOutlet UIButton *btnSeeSelected;

@property(strong, nonatomic) Questions *question;

@property (nonatomic, strong) UIViewController *myAnswersVC;

@end

