//
//  Client.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Client : NSObject

@property (nonatomic) NSString * companyName;
@property (nonatomic) NSString * division;
@property (nonatomic) NSString * SICNumber;
@property (nonatomic) NSString * auditedSite;
@property (nonatomic) NSString * address;
@property (nonatomic) NSString * cityStateProvince;
@property (nonatomic) NSString * country;
@property (nonatomic) NSInteger * postalCode;
@property (nonatomic) NSString * auditDate;
@property (nonatomic) NSString * auditor;
@property (nonatomic) NSInteger * numEmployees;
@property (nonatomic) BOOL baselineAudit;
@property (nonatomic) NSString * licenseNum;
@property (nonatomic) NSArray * Audits;



@end
