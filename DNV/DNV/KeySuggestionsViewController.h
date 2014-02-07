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

@interface KeySuggestionsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) Audit *audit;

@property (strong, nonatomic) IBOutlet UIView *keySugsPDFView;

@property (strong, nonatomic) IBOutlet UITableView *KeySugsTableView;

@property (strong,nonatomic) NSMutableArray *thumbsDowndQuestions;
@property (strong,nonatomic) NSMutableArray *positions;

@end
