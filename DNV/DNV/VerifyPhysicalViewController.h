//
//  VerifyPhysicalViewController.h
//  DNV
//
//  Created by Jaime Martinez on 2/3/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNVDatabaseManagerClass.h"

@interface VerifyPhysicalViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *arrPhysicalRows;
- (IBAction)btnAddRowToTable:(id)sender;


@property (weak, nonatomic) IBOutlet UITableView *tblPhysical;

@property(nonatomic, strong) DNVDatabaseManagerClass *dnvDB;

@end
