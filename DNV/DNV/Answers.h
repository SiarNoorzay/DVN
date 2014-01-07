//
//  Answers.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answers : NSDictionary

@property (nonatomic) NSString * answerText;
@property (nonatomic) float pointsPossibleOrMultiplier;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) NSArray * Questions;


-(id)initWithAnswer:(NSDictionary *)answerDictionary;

@end
