//
//  AttachmentsPopOverViewController.h
//  DNV
//
//  Created by Jaime Martinez on 2/12/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "Questions.h"

@interface AttachmentsPopOverViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblLocalAttachments;
@property (weak, nonatomic) IBOutlet UITableView *tblQuestionAttachments;

@property (strong, nonatomic) NSMutableArray *arrLocalFiles;
@property (strong, nonatomic) NSMutableArray *arrQuestionFiles;

- (IBAction)btnDeleteSelected:(id)sender;
- (IBAction)btnSeeSelected:(id)sender;

- (IBAction)btnAttachFile:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAttachFile;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteSelected;
@property (weak, nonatomic) IBOutlet UIButton *btnSeeSelected;

@property(strong, nonatomic) Questions *question;

@end
