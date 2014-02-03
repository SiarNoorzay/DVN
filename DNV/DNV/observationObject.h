//
//  observationObject.h
//  DNV
//
//  Created by Jaime Martinez on 2/3/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface observationObject : NSObject

@property (nonatomic, strong) NSString * strDescription;
@property (nonatomic, assign) int iConfirmed;
@property (nonatomic, assign) int iNotConfrimed;
@property (nonatomic, assign) float fPercentage;

@end
