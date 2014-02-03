//
//  AuditSelectionViewController.h
//  DNV
//
//  Created by USI on 1/7/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DNVDatabaseManagerClass.h"
#import "Audit.h"

@class DBRestClient;


@interface AuditSelectionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    DBRestClient *restClient;
    DBRestClient *restClient2;
}

@property (weak, nonatomic) NSString * companyName;
@property (strong, nonatomic) IBOutlet UILabel *companyNameLbl;

@property (strong, nonatomic) IBOutlet UITableView * auditListTable;

@property (strong, nonatomic) NSString *dbNewFolderPath;
@property (nonatomic) NSArray *audits;

@property (strong, nonatomic) DNVDatabaseManagerClass * dnvDBManager;
@property NSString * directoryPath;
@property (strong, nonatomic) Audit * audit;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
