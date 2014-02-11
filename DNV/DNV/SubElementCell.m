//
//  SubElementCell.m
//  DNV
//
//  Created by USI on 1/15/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "SubElementCell.h"

@implementation SubElementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnNASubElement:(id)sender
{
    if( self.btnNASubElement.tag == 0)
    {
        self.btnNASubElement.tag = 1;
        [self.btnNASubElement setImage:[UIImage imageNamed:@"not_applicable_icon"] forState:UIControlStateNormal];
    
        
        //toggle all questions in this element to N/A, call it on elemenets subelements vc
    }
    else
    {
        self.btnNASubElement.tag = 0;
        [self.btnNASubElement setImage:[UIImage imageNamed:@"not_applicable_icon_gray"] forState:UIControlStateNormal];
        
        //toggle all questions in this element to not N/A, call it on elemenets subelements vc
    }
}
@end
