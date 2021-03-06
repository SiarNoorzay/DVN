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
    if( self.theSubElement.isApplicable )
    {
        UIAlertView * deleteAuditAlert = [[UIAlertView alloc] initWithTitle: @"N/A Sub Element" message: @"Are you sure you want to set this sub element to not applicable? Note, all saved answers will be reset to 0." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
        
        [deleteAuditAlert show];
    }
    else
    {
        [self.theElementSubElementVC.spinner startAnimating];
        
        self.theSubElement.isApplicable = !self.theSubElement.isApplicable;
        [self setNAImage:self.theSubElement.isApplicable];
        
        //toggle all questions in this element to not N/A or not according to tag, call it on elemenets subelements vc
        [self.theElementSubElementVC setNAToSubElementsQuestions:self.theSubElement ifBool:self.theSubElement.isApplicable];
        
        [self.theElementSubElementVC refreshView];
        
        [self.theElementSubElementVC.spinner stopAnimating];
    }
}

-(void)setNAImage:(BOOL)isApplicable
{
    if( !isApplicable)
        [self.btnNASubElement setBackgroundImage:[UIImage imageNamed:@"no.png"] forState:UIControlStateNormal];
    else
        [self.btnNASubElement setBackgroundImage:[UIImage imageNamed:@"yes-logo-green.png"] forState:UIControlStateNormal];
}

#pragma mark Alertview method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //Code for OK button
    }
    if (buttonIndex == 1)
    {
        
        [self.theElementSubElementVC.spinner startAnimating];
        
        self.theSubElement.isApplicable = !self.theSubElement.isApplicable;
        [self setNAImage:self.theSubElement.isApplicable];
        
        //toggle all questions in this element to not N/A or not according to tag, call it on elemenets subelements vc
        [self.theElementSubElementVC setNAToSubElementsQuestions:self.theSubElement ifBool:self.theSubElement.isApplicable];
        
        [self.theElementSubElementVC refreshView];
        
        [self.theElementSubElementVC.spinner stopAnimating];
    }
}


@end
