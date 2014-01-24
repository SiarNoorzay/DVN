//
//  Report.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MergeClass.h"

@interface Report : NSDictionary

@property (nonatomic) NSString * summary;
@property (nonatomic) NSString * preparedBy;
@property (nonatomic) NSString * approvedBy;
@property (nonatomic) NSString * projectNum;
@property (nonatomic) NSString * conclusion;
@property (nonatomic) NSString * methodologyDiagramLocation;
@property (nonatomic) NSString * clientRef;
@property (nonatomic) NSString * executiveSummary;



-(id)initWithReport:(NSDictionary *)dictionary;

-(Report *)mergeReports:(Report *)primaryReport with:(Report *)secondaryReport;

@end
