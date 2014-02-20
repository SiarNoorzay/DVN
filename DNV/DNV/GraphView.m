//
//  GraphView.m
//  DNV
//
//  Created by USI on 1/22/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "GraphView.h"
#import "ECCommon.h"
#import "ECGraphPoint.h"
#import "ECGraphLine.h"
#import "ECGraphItem.h"

@implementation GraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithElementNames:(NSArray*)names andPercents:(NSArray*)percents
{
    self = [super init];
    if (self){
        self.elementNames = names;
        self.elementPercent = percents;
    }
    return self;
    
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

-(void)drawRect:(CGRect)rect {
    self.frame  = CGRectMake(0, 0, 612, 360);
    if (self.elementNames == nil || self.elementNames.count == 0) {
        NSLog(@"SHOULD NEVER SEE THIS");
        return;
    }
    int numberOfEles = [self.elementNames count];
    //if (numberOfEles == 0) numberOfEles = 1;
    
    float width = (600/ numberOfEles) - 10;
    if (width<25) {
        width = 25;
    }
    else if (width >100)
    {
        width = 100;
    }
    // Drawing code
	CGContextRef _context = UIGraphicsGetCurrentContext();
   // -35, -42, 612, 260
	ECGraph *graph = [[ECGraph alloc] initWithFrame:CGRectMake(15,75, 600, 235) withContext:_context isPortrait:NO];
    
	NSLog(@"draw rect %@", [self.elementNames objectAtIndex:0]);
    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:numberOfEles];
    
    for (int i = 0; i < numberOfEles; i++) {
        ECGraphItem *item = [[ECGraphItem alloc] init];
        item.isPercentage = YES;
        item.yValue = [[self.elementPercent objectAtIndex:i] floatValue];
        item.width = width;
        item.name = [self.elementNames objectAtIndex:i];
        int nameMaxLength = (((width * 1.5) /10) + 3);
        if (item.name.length > nameMaxLength) {
            item.name = [item.name substringToIndex: nameMaxLength];
        }
        [itemsArray addObject:item];
        
    }
    
    //
    //	ECGraphItem *item1 = [[ECGraphItem alloc] init];
    //	item1.isPercentage = YES;
    //	item1.yValue = 80;
    //	item1.width = 35;
    //	item1.name = @"item1";
    //
    //	ECGraphItem *item2 = [[ECGraphItem alloc] init];
    //	item2.isPercentage = YES;
    //	item2.yValue = 35.3;
    //	item2.width = 35;
    //	item2.name = @"item2";
    //
    //	ECGraphItem *item3 = [[ECGraphItem alloc] init];
    //	item3.isPercentage = YES;
    //	item3.yValue = 45;
    //	item3.width = 35;
    //	item3.name = @"item3";
    //
    //	ECGraphItem *item4 = [[ECGraphItem alloc] init];
    //	item4.isPercentage = YES;
    //	item4.yValue = 78.6;
    //	item4.width = 35;
    //	item4.name = @"item4";
    //
    //	ECGraphItem *item5 = [[ECGraphItem alloc] init];
    //	item5.isPercentage = YES;
    //	item5.yValue = 94.45;
    //	item5.width = 35;
    //	item5.name = @"item5";
    //
    //	NSArray *items = [[NSArray alloc] initWithObjects:item1,item2,item3,item4,item5,nil];
    
    //UIGraphicsBeginImageContext(rect.size);
    
	[graph setYaxisTitle:@"Percentage"];
    if (self.isAudit)
    {
        [graph setGraphicTitle:@"Elements of Audit"];
        [graph setXaxisTitle:@"Elements"];

    }else
    {
        [graph setGraphicTitle:[NSString stringWithFormat:@"Element: %@ ",self.name]];
        [graph setXaxisTitle:@"Sub-Elements"];
    }
	[graph setDelegate:self];
	[graph setBackgroundColor:[UIColor whiteColor]];// colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]];
	[graph drawHistogramWithItems:itemsArray lineWidth:2 color:[UIColor blackColor]];
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //
    //    return image;
}


@end
