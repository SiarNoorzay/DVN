//
//  VerifyQuestionsViewController.h
//  DNV
//
//  Created by USI on 1/14/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Audit.h"
#import "Elements.h"
#import "SubElements.h"
#import "Questions.h"

#import "DNVDatabaseManagerClass.h"

@class DBRestClient;

@interface VerifyQuestionsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    DBRestClient * restClient;
}

@property(nonatomic, strong) DNVDatabaseManagerClass *dnvDB;

@property (strong,atomic) NSMutableArray *allSublayeredQuestions;

@property NSArray * verifyQuestions;

@property (strong, nonatomic) NSString * auditPath;
@property (strong,nonatomic) Audit * audit;

@property (strong, nonatomic) Elements * element;
@property (strong, nonatomic) NSArray * elementsArray;

@property (strong, nonatomic) SubElements * subElement;
@property (strong, nonatomic) NSArray * subElementsArray;

@property (strong, nonatomic) Questions * questions;

@property (strong, nonatomic) IBOutlet UITableView *VerifyQuestionsTable;


@end
