//
//  Questions.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Questions : NSObject

@property (nonatomic) BOOL isCompleted;
@property (nonatomic) float  pointsPossible;
@property (nonatomic) float  pointsAwarded;
@property (nonatomic) NSString * questionText;
@property (nonatomic) NSString * helpText;
@property (nonatomic) BOOL isApplicable;
@property (nonatomic) NSString * notes;
@property (nonatomic) BOOL needsVerifying;
@property (nonatomic) NSString * verifyDoneBy;
@property (nonatomic) NSArray * attachmentsLocationArray;
@property (nonatomic) NSArray * imageLocationArray;
@property (nonatomic) NSArray * Answers;
@property (nonatomic) enum questionType;
@property (nonatomic) BOOL isThumbsUp;
@property (nonatomic) BOOL isThumbsDown;



@end
