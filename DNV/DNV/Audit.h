//
//  Audit.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Report.h"
#import "Client.h"



@interface Audit : NSDictionary

@property (nonatomic) NSInteger auditType;
@property (nonatomic) NSString * name;
@property (nonatomic) NSArray * Elements;
@property (nonatomic) float physicalConditionScore;
@property (nonatomic) NSString * awardLevel;
@property (nonatomic) NSString * lastModefied;
@property (nonatomic) Report * report;
@property (nonatomic) Client * client;

-(id)initWithAudit:(NSDictionary *)auditDictionary;


@end
