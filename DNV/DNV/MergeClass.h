//
//  MergeClass.h
//  DNV
//
//  Created by Jaime Martinez on 1/21/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MergeClass : NSObject

@property( nonatomic ) BOOL bRank2Higher;

//Merge methods
-(BOOL)mergeBool:(BOOL)primaryVal with:(BOOL)secondaryVal;
-(int)mergeInt:(int)primaryVal with:(int)secondaryVal;
-(float)mergeFloat:(float)primaryVal with:(float)secondaryVal;
-(NSString *)mergeString:(NSString *)primaryVal with:(NSString *)secondaryVal;
-(NSArray *)mergeArray:(NSArray *)primaryVal with:(NSArray *)secondaryVal;

@end
