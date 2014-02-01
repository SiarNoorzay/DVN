//
//  Answers.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MergeClass.h"

@interface Answers : NSDictionary

@property (nonatomic) int answerID;
@property (nonatomic) NSString * answerText;
@property (nonatomic) float pointsPossible;
@property (nonatomic) BOOL isSelected;

-(id)initWithAnswer:(NSDictionary *)answerDictionary;

-(Answers *)mergeAnswer:(Answers *)primaryAnswer with:(Answers *)secondaryAnswer;

-(NSDictionary*)toDictionary;

@end

