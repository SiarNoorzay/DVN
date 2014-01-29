//
//  SubElements.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Questions.h"

@interface SubElements : NSDictionary

@property (nonatomic) int subElementID;
@property (nonatomic) BOOL isCompleted;
@property (nonatomic) NSString * name;
@property (nonatomic) float  pointsPossible;
@property (nonatomic) float  pointsAwarded;
@property (nonatomic) NSArray * Questions;
@property (nonatomic) float modefiedNAPoints;

@property (nonatomic) NSArray * zeroIfNoPointsFor;

-(id)initWithSubElement:(NSDictionary *)subElementDictionary;

-(SubElements *)mergeSubElements:(SubElements *)primarySubElements with:(SubElements *)secondarySubElements;

@end
