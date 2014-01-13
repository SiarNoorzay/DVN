//
//  ListOfWIPViewController.h
//  DNV
//
//  Created by USI on 1/9/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBRestClient;

@interface ListOfWIPViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    DBRestClient *restClient;
}

@property (strong, nonatomic) NSArray * sectionHeaders;

@property (strong, nonatomic) UIPopoverController * wipPopOver;

@property (strong, nonatomic) NSString *dbWIPFolderPath;

@property (strong, nonatomic) NSArray * wips;

@property (nonatomic) int wipChoice;

@property (strong, nonatomic) IBOutlet UITableView *wipAuditTable;

-(void)goToWIPChoice;

@end
