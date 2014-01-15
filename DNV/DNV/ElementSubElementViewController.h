//
//  ElementSubElementViewController.h
//  DNV
//
//  Created by USI on 1/8/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Audit.h"
#import "Elements.h"
#import "SubElements.h"

@class DBRestClient;

@interface ElementSubElementViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    DBRestClient * restClient;    
}

@property (strong, nonatomic) NSString * auditPath;
@property (strong, nonatomic) NSString * audType;
@property (strong,nonatomic) Audit * aud;

@property (strong, nonatomic) Elements * ele;
@property (strong, nonatomic) NSArray * listOfElements;

@property (strong, nonatomic) SubElements * subEle;
@property (strong, nonatomic) NSArray * listOfSubElements;

@property NSString * directoryPath;

@property (strong, nonatomic) NSMutableArray * JSONList;

@property (strong, nonatomic) IBOutlet UILabel *auditSelectLbl;

@property (strong, nonatomic) IBOutlet UIPickerView *elementPicker;

@property (strong, nonatomic) IBOutlet UITableView *subElementTable;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
