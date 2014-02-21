//
//  ElementSubelementProfilesViewController.h
//  DNV
//
//  Created by USI on 1/24/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Audit.h"
#import "DNVDatabaseManagerClass.h"



@interface ElementSubelementProfilesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (strong,nonatomic) Audit *audit;
@property (strong, nonatomic) IBOutlet UILabel *lblProfilesTitle;
@property (strong, nonatomic) DNVDatabaseManagerClass * dnvDBManager;


@property (strong, nonatomic) IBOutlet UIView *profilesPDFView;
//@property (strong, nonatomic) NSArray *cellArrary;
@property (strong, nonatomic) NSMutableArray *thumbedQuestions;//stores both thumbs up and thumbs down questions along with other labels

@property (strong,nonatomic) UIView* parentView; //used for finding cell from textView delegate

@property (strong, nonatomic) IBOutlet UITableView *resultsTableView;
@property (strong,atomic) NSMutableArray *allSublayeredQuestions;


@end
