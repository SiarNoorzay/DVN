//
//  SubElementCell.h
//  DNV
//
//  Created by USI on 1/15/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElementSubElementViewController.h"
#import "SubElements.h"

@interface SubElementCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *subElementName;
@property (strong, nonatomic) IBOutlet UILabel *points;
@property (strong, nonatomic) IBOutlet UIImageView *image;

- (IBAction)btnNASubElement:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnNASubElement;

@property (strong, nonatomic) ElementSubElementViewController *theElementSubElementVC;

@property (strong, nonatomic) SubElements *theSubElement;

-(void)setNAImage;

@end
