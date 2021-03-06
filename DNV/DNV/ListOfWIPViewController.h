//
//  ListOfWIPViewController.h
//  DNV
//
//  Created by USI on 1/9/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNVDatabaseManagerClass.h"

@class DBRestClient;

@interface ListOfWIPViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    DBRestClient *restClient;
}

@property (strong, nonatomic) DNVDatabaseManagerClass * dnvDBManager;
@property (strong, nonatomic) NSArray * localWips;

@property (strong, nonatomic) NSArray * sectionHeaders;

@property (strong, nonatomic) NSString * dbWIPFolderPath;
@property (strong, nonatomic) NSString * ogdbWIPFolderPath;


@property (strong, nonatomic) NSArray * wips;

@property (strong, nonatomic) IBOutlet UITableView *wipAuditTable;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
