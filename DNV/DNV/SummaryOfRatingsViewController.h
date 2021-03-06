//
//  SummaryOfRatingsViewController.h
//  DNV
//
//  Created by USI on 1/21/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Audit.h"
#import "Elements.h"
#import "GraphView.h"


@interface SummaryOfRatingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>

@property (strong, atomic) Audit *audit;

@property (strong, nonatomic) NSArray *elementsArray;

@property (strong, nonatomic) IBOutlet UIView *ratingsPDFView;


@property (strong, nonatomic) IBOutlet UITableView *ElementRatingsTableView;

@property (strong, nonatomic) IBOutlet UITableView *graphsTableView;


@property (strong, nonatomic) IBOutlet UILabel *possibleLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPossibleLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalAwardedLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPercentageLabel;

@property (strong, nonatomic) IBOutlet UILabel *evaluatedLabel;
@property (strong, nonatomic) IBOutlet UILabel *evaluatedPossibleLabel;
@property (strong, nonatomic) IBOutlet UILabel *evaluatedAwardedLabel;
@property (strong, nonatomic) IBOutlet UILabel *evaluatedPercentageLabel;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSArray *graphViews;

@property (weak, nonatomic) IBOutlet UILabel *lblElementTitle;

@end
