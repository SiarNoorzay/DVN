//
//  AuditSelectionViewController.h
//  DNV
//
//  Created by USI on 1/7/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Audit.h"

@interface AuditSelectionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView * auditListTable;

@property (strong, nonatomic) Audit * aud;

@end
