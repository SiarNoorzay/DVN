//
//  verificationCell.m
//  DNV
//
//  Created by Jaime Martinez on 2/3/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "verificationCell.h"

@implementation verificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.iConfirm = [self.lblConfirmed.text intValue];
        self.iNotConfirm = [self.lblNotConfirmed.text intValue];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)stpConfirmed:(id)sender
{
    self.lblConfirmed.text = [NSString stringWithFormat:@"%d", (int)[self.stpConfirmed stepValue] ];
}

- (IBAction)stpNotConfirmed:(id)sender
{
    self.lblNotConfirmed.text = [NSString stringWithFormat:@"%d", (int)[self.stpNotConfirmed stepValue] ];
}

-(void)setPercent
{
    
}

@end
