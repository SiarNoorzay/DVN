//
//  VerifyRecordsViewController.h
//  DNV
//
//  Created by Jaime Martinez on 2/3/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyRecordsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *arrRecordRows;
@property (weak, nonatomic) IBOutlet UITableView *tblRecords;
- (IBAction)btnAddToTable:(id)sender;

@end
