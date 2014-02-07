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
    self.lblConfirmed.text = [NSString stringWithFormat:@"%d", (int)[self.stpConfirmed value] ];
    [self setPercent];
    
    self.theObject.confirmedCount = [self.lblConfirmed.text intValue];
    
    [self.dnvDB updateOVerify:self.theObject];
}

- (IBAction)stpNotConfirmed:(id)sender
{
    self.lblNotConfirmed.text = [NSString stringWithFormat:@"%d", (int)[self.stpNotConfirmed value] ];
    [self setPercent];
    
    self.theObject.notConfirmedCount = [self.lblNotConfirmed.text intValue];
    
    [self.dnvDB updateOVerify:self.theObject];
}

-(void)setPercent
{
    if( self.stpConfirmed.value > 0 || self.stpNotConfirmed.value > 0 )
        self.lblPercent.text = [NSString stringWithFormat:@"%.2f", 100 * (self.stpConfirmed.value/ (self.stpConfirmed.value + self.stpNotConfirmed.value)) ];
    else
        self.lblPercent.text = @"0";
    
    self.theObject.percentComplete = [self.lblPercent.text floatValue];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Enter a description"]) {
        textView.text = @"";
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( [text isEqualToString:@"\n"] )
    {
        [textView resignFirstResponder];
        self.theObject.description = textView.text;
        return NO;
    }
    
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Enter a description";
    }
    
    [self.dnvDB updateOVerify:self.theObject];
}

@end
