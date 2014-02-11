//
//  imageCell.m
//  DNV
//
//  Created by USI on 2/11/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "imageCell.h"

@implementation imageCell

@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc] init];
        imageView.frame = frame;
        
        [self addSubview:imageView];
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
