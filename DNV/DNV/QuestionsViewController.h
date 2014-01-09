//
//  QuestionsViewController.h
//  DNV
//
//  Created by USI on 1/9/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Questions.h"

@interface QuestionsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray * questionArray;
@property (strong, nonatomic) IBOutlet UITableView *questionsTableView;


@end
