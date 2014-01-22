//
//  MergeClass.m
//  DNV
//
//  Created by Jaime Martinez on 1/21/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "MergeClass.h"

@implementation MergeClass

////Logic for bool merging
-(BOOL)mergeBool:(BOOL)primaryVal with:(BOOL)secondaryVal
{
    ////Logic for bool types
    //null primary value, use secondary
    if( [NSNumber numberWithBool:primaryVal] == NULL )
        return secondaryVal;
    //secondary rank is higher and not null
    else if( _bRank2Higher && [NSNumber numberWithBool:secondaryVal]!= NULL)
        return secondaryVal;
    //use primary if none of the above apply
    else
        return primaryVal;
}

////Logic for int merging
-(int)mergeInt:(int)primaryVal with:(int)secondaryVal
{
    //null primary value, use secondary
    if( [NSNumber numberWithInt:primaryVal ] == NULL  )
        return secondaryVal;
    //secondary rank is higher and not empty use secondary value
    else if( _bRank2Higher && [NSNumber numberWithInt:secondaryVal]!= NULL)
        return secondaryVal;
    //use primary if none of the above apply
    else
        return primaryVal;
}

////Logic for float merging
-(float)mergeFloat:(float)primaryVal with:(float)secondaryVal
{
    //null primary value, use secondary
    if( [NSNumber numberWithFloat:primaryVal ] == NULL  )
        return secondaryVal;
    //secondary rank is higher and not empty use secondary value
    else if( _bRank2Higher && [NSNumber numberWithFloat:secondaryVal]!= NULL)
        return secondaryVal;
    //use primary if none of the above apply
    else
        return primaryVal;
}

////Logic for string merging
-(NSString *)mergeString:(NSString *)primaryVal with:(NSString *)secondaryVal
{
    //null or empty primary value, use secondary
    if( primaryVal == NULL || !(primaryVal.length  > 0) )
        return secondaryVal;
    //secondary rank is higher and not empty use secondary value
    else if( _bRank2Higher && secondaryVal != NULL && secondaryVal.length > 0 )
        return secondaryVal;
    //use primary if none of the above apply
    else
        return primaryVal;
}

////Logic for array merging
-(NSArray *)mergeArray:(NSArray *)primaryVal with:(NSArray *)secondaryVal
{
    //combine objects from both arrays with no duplicates and return
    NSMutableSet *unique = [[NSMutableSet alloc]initWithArray:primaryVal];
    [unique addObjectsFromArray:secondaryVal];
    return [unique allObjects];
}

@end
