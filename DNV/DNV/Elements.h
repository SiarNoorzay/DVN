//
//  Elements.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubElements.h"

@interface Elements : NSDictionary

//only set in refreshview of elesubelement view

@property (nonatomic) int elementID;
@property (nonatomic) BOOL isCompleted;

@property (nonatomic) BOOL isApplicable;

@property (nonatomic) NSString * name;
@property (nonatomic) BOOL isRequired;
@property (nonatomic) float  pointsPossible;
@property (nonatomic) float  pointsAwarded;
@property (nonatomic) NSArray * Subelements;

@property (nonatomic) float modefiedNAPoints;

@property (nonatomic) NSMutableArray * zeroIfNoPointsFor;


-(id)initWithElement:(NSDictionary *)elementDictionary;

-(Elements *)mergeElements:(Elements *)primaryElements with:(Elements *)secondaryElements ofRank:(BOOL)bRank2Higher;

-(NSDictionary*)toDictionary;

@end
