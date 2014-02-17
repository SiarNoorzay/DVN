//
//  QuestionsViewController.h
//  DNV
//
//  Created by USI on 1/9/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNVDatabaseManagerClass.h"

#import "Questions.h"
#import "QuestionCell.h"

#import "Audit.h"

@interface QuestionsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) DNVDatabaseManagerClass * dnvDBManager;


@property (nonatomic) NSArray * questionArray;
@property (strong, nonatomic) IBOutlet UITableView *questionsTableView;

@property(nonatomic) int elementNumber;
@property(nonatomic) int subEleNumber;

@property (strong, nonatomic) Audit * audit;

@end
