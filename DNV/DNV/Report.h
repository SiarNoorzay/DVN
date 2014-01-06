//
//  Report.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Report : NSObject

@property (nonatomic) NSString * summary;
@property (nonatomic) NSString * preparedBy;
@property (nonatomic) NSString * verifiedBy;
@property (nonatomic) NSString * approvedBy;
@property (nonatomic) NSString * projectNum;
@property (nonatomic) NSString * conclusion;
@property (nonatomic) NSString * methodologyDiagramLocation;

@end
