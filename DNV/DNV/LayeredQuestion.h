//
//  LayeredQuestion.h
//  DNV
//
//  Created by USI on 1/28/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Questions.h"


@interface LayeredQuestion : NSObject

@property (nonatomic,strong) Questions *question;
@property (nonatomic,strong) NSMutableArray  *subIndexes;
@property (nonatomic) BOOL  shouldBeEnabled;


@end