//
//  GraphViewCell.m
//  DNV
//
//  Created by USI on 2/11/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "GraphViewCell.h"

@implementation GraphViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier graphView:(GraphView*)grphView

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.graphViewImage = grphView;
    }
    return self;
}

-(id)initWithGraph:(GraphView*)grphView reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.graphViewImage = grphView;
        self.elementSubName.text = grphView.name;
    }
    return self;
}

-(id)initWithGraph:(GraphView*)grphView
{
    self = [super init];
    if (self) {
        self.graphViewImage = grphView;
        self.elementSubName.text = grphView.name;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
