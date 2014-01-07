//
//  SubElements.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubElements : NSDictionary

@property (nonatomic) BOOL isCompleted;
@property (nonatomic) NSString * name;
@property (nonatomic) float  pointsPossible;
@property (nonatomic) float  pointsAwarded;
@property (nonatomic) NSArray * Questions;

-(id)initWithSubElement:(NSDictionary *)subElementDictionary;

@end
