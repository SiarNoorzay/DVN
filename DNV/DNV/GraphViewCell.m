//
//  GraphViewCell.m
//  DNV
//
//  Created by USI on 2/11/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "GraphViewCell.h"

@implementation GraphViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithGraph:(GraphView*)grphView{
    self = [super init];
    if (self) {
        self.graphViewImage = grphView;
        //        self.elementSubName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
        //        self.elementSubName.text = grphView.name;
        [self addSubview:self.graphViewImage];
    }
    return self;
}

-(id)initWithGraph:(GraphView*)grphView reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.graphViewImage = grphView;
//        self.elementSubName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
//        self.elementSubName.text = grphView.name;
        [self addSubview:self.graphViewImage];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
