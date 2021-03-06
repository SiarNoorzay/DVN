//
//  VerifyRecordsViewController.h
//  DNV
//
//  Created by Jaime Martinez on 2/3/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNVDatabaseManagerClass.h"

@interface VerifyRecordsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblRecords;
- (IBAction)btnAddToTable:(id)sender;

@property(nonatomic, strong) DNVDatabaseManagerClass *dnvDB;

@end
