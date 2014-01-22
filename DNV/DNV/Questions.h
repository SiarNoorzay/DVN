//
//  Questions.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Answers.h"

@interface Questions : NSDictionary

@property (nonatomic) BOOL isCompleted;
@property (nonatomic) float  pointsPossible;
@property (nonatomic) float  pointsAwarded;
@property (nonatomic) NSString * questionText;
@property (nonatomic) NSString * helpText;
@property (nonatomic) BOOL isApplicable;
@property (nonatomic) BOOL isVerifyDone;
@property (nonatomic) NSString * notes;
@property (nonatomic) int needsVerifying;
@property (nonatomic) NSArray * attachmentsLocationArray;
@property (nonatomic) NSArray * imageLocationArray;
@property (nonatomic) NSArray * Answers;
@property (nonatomic) int questionType;
@property (nonatomic) BOOL isThumbsUp;
@property (nonatomic) BOOL isThumbsDown;
@property (nonatomic) NSArray * layeredQuestion;
@property (nonatomic) float pointsNeededForLayered;
@property (nonatomic) NSArray * layeredQuesions;

-(id)initWithQuestion:(NSDictionary *)questionDictionary;

-(Questions *)mergeQuestion:(Questions *)primaryQuestion with:(Questions *)secondaryQuestion;

@end
