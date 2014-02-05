//
//  AuditSelectionViewController.h
//  DNV
//
//  Created by USI on 1/7/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBRestClient;


@interface AuditSelectionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    DBRestClient *restClient;
}

@property (weak, nonatomic) NSString * companyName;
@property (strong, nonatomic) IBOutlet UILabel *companyNameLbl;

@property (strong, nonatomic) IBOutlet UITableView * auditListTable;

@property (strong, nonatomic) NSString *dbNewFolderPath;
@property (nonatomic) NSArray *audits;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
