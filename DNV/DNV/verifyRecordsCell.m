//
//  verifyRecordsCell.m
//  DNV
//
//  Created by Jaime Martinez on 2/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "verifyRecordsCell.h"

@implementation verifyRecordsCell

@synthesize imgGreenCheck;

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

- (IBAction)btnCheckBox:(id)sender
{
    [self.btnCheckBox setUserInteractionEnabled:false];
    
    self.theObject.isConfirmed = !self.theObject.isConfirmed;
    
    [UIView animateWithDuration:.3 animations:^{
        [self setGreenCheck:self.theObject.isConfirmed];
      
    } completion:^(BOOL finished) {
        [self.btnCheckBox setUserInteractionEnabled:true];
        [self.dnvDB updateRVerify:self.theObject];
    }];

}

-(void)setGreenCheck: (BOOL)bToSet
{
    if( imgGreenCheck == nil)
    {
        imgGreenCheck = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"check.png"]];
        [imgGreenCheck setFrame:CGRectMake(0, self.btnCheckBox.frame.size.height, 0, 0)];
        [self.btnCheckBox addSubview:imgGreenCheck];
    }
    
    if(bToSet)
    {
        [imgGreenCheck setFrame:CGRectMake(0, 0, self.btnCheckBox.frame.size.width, self.btnCheckBox.frame.size.height)];
    }
    else
    {
        [imgGreenCheck setFrame:CGRectMake(0, self.btnCheckBox.frame.size.height, 0, 0)];
    }
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
    
    [self.dnvDB updateRVerify:self.theObject];
}

@end
