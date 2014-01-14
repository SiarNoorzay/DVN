//
//  WIPAuditFilesViewController.h
//  DNV
//
//  Created by USI on 1/13/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBRestClient;

@interface WIPAuditFilesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    DBRestClient * restClient;
}



@property (strong, nonatomic) NSString * wipAuditType;
@property (strong, nonatomic) NSString * wipAuditPath;
@property (strong, nonatomic) NSMutableArray * JSONList;

@property (strong, nonatomic) UIPopoverController * wipPopOver;

@property (nonatomic) int wipJSONChoice;

@property (strong, nonatomic) IBOutlet UITableView * wipJSONFileTable;

-(void)goToWIPChoice;

@end
