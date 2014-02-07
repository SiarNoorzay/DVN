//
//  VerifyInterivewsViewController.h
//  DNV
//
//  Created by Jaime Martinez on 2/3/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNVDatabaseManagerClass.h"

@interface VerifyInterivewsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *arrInterviewRows;

@property (weak, nonatomic) IBOutlet UITableView *tblInterview;
- (IBAction)btnAddRow:(id)sender;

@property(nonatomic, strong) DNVDatabaseManagerClass *dnvDB;

@end
