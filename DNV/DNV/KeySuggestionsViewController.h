//
//  KeySuggestionsViewController.h
//  DNV
//
//  Created by USI on 1/24/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Audit.h"
#import "KeySuggesstionCell.h"
#import "DNVDatabaseManagerClass.h"


@interface KeySuggestionsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextViewDelegate>

@property (strong,nonatomic) Audit *audit;
@property (strong, nonatomic) DNVDatabaseManagerClass * dnvDBManager;

@property (strong, nonatomic) IBOutlet UIView *keySugsPDFView;

@property (strong, nonatomic) IBOutlet UITableView *KeySugsTableView;

@property (strong,nonatomic) NSMutableArray *thumbsDowndQuestions;
@property (strong,nonatomic) NSMutableArray *positions;

@property (strong,nonatomic) UIView* parentView;//used for finding cell from textView delegate
@property (strong, nonatomic) IBOutlet UILabel *lblKeysTitle;

@end
