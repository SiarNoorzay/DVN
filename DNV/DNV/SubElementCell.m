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
    self.theSubElement.isApplicable = !self.theSubElement.isApplicable;
    [self setNAImage:self.theSubElement.isApplicable];
    
    //toggle all questions in this element to not N/A or not according to tag, call it on elemenets subelements vc
    [self.theElementSubElementVC setNAToSubElementsQuestions:self.theSubElement ifBool:self.theSubElement.isApplicable];
    
    [self.theElementSubElementVC refreshView];
}

-(void)setNAImage:(BOOL)isApplicable
{
    if( !isApplicable)
        [self.btnNASubElement setBackgroundImage:[UIImage imageNamed:@"no.png"] forState:UIControlStateNormal];
    else
        [self.btnNASubElement setBackgroundImage:[UIImage imageNamed:@"yes.png"] forState:UIControlStateNormal];
}

@end
