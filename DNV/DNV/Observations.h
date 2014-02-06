//
//  Observations.h
//  DNV
//
//  Created by Jaime Martinez on 2/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MergeClass.h"

@interface Observations : NSDictionary

@property (nonatomic) int observationID;

@property (nonatomic) NSString * description;
@property (nonatomic) int confirmedCount;
@property (nonatomic) int notConfirmedCount;
@property (nonatomic) float percentComplete;

-(id)initWithObservation:(NSDictionary *)observationDictionary;

-(Observations *)mergeObservations:(Observations *)primaryObservations with:(Observations *)secondaryObservations ofRank:(BOOL)bRank2Higher;

-(NSDictionary*)toDictionary;

@end
