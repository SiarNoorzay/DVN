//
//  Records.h
//  DNV
//
//  Created by Jaime Martinez on 2/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MergeClass.h"

@interface Records : NSDictionary

@property (nonatomic) int recordID;

@property (nonatomic) NSString * description;
@property (nonatomic) bool isConfirmed;

-(id)initWithRecord:(NSDictionary *)recordDictionary;

-(Records *)mergeRecords:(Records *)primaryObservations with:(Records *)secondaryObservations ofRank:(BOOL)bRank2Higher;

-(NSDictionary*)toDictionary;


@end
