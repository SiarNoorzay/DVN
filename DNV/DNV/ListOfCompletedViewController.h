//
//  ListOfCompletedViewController.h
//  DNV
//
//  Created by USI on 1/15/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBRestClient;

@interface ListOfCompletedViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    DBRestClient *restClient;
}

@property (strong, nonatomic) NSArray * sectionHeaders;

@property (strong, nonatomic) NSString * dbCompletedFolderPath;

@property (strong, nonatomic) NSArray * completed;

@property (strong, nonatomic) UIPopoverController * completedPopOver;

@property int completedChoice;

@property (strong, nonatomic) IBOutlet UITableView *completedAuditTable;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


-(void)goToCompletedChoice;

@end
