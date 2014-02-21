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
    if( [NSNumber numberWithBool:primaryVal] == NULL || !primaryVal)
        return secondaryVal;
    //secondary rank is higher and not null
    else if( _bRank2Higher && [NSNumber numberWithBool:secondaryVal]!= NULL && secondaryVal)
        return secondaryVal;
    //use primary if none of the above apply
    else
        return primaryVal;
}

////Logic for int merging
-(int)mergeInt:(int)primaryVal with:(int)secondaryVal
{
    //null primary value, use secondary
    if( [NSNumber numberWithInt:primaryVal ] == NULL  || primaryVal == 0)
        return secondaryVal;
    //secondary rank is higher and not empty use secondary value
    else if( _bRank2Higher && [NSNumber numberWithInt:secondaryVal]!= NULL && secondaryVal != 0)
        return secondaryVal;
    //use primary if none of the above apply
    else
        return primaryVal;
}

////Logic for float merging
-(float)mergeFloat:(float)primaryVal with:(float)secondaryVal
{
    //null primary value, use secondary
    if( [NSNumber numberWithFloat:primaryVal ] == NULL || primaryVal == 0  )
        return secondaryVal;
    //secondary rank is higher and not empty use secondary value
    else if( _bRank2Higher && [NSNumber numberWithFloat:secondaryVal]!= NULL && secondaryVal != 0)
        return secondaryVal;
    //use primary if none of the above apply
    else
        return primaryVal;
}
//special case* for isCompleted (0 from person with highest rank)
-(float)mergeFloat:(float)primaryVal with:(float)secondaryVal bCompletedPrimary:(BOOL)bPrimary bCompletedSecondary:(BOOL)bSecondary
{
    //null primary value, use secondary
    if( ([NSNumber numberWithFloat:primaryVal ] == NULL || primaryVal == 0 ) && !bPrimary)
        return secondaryVal;
    //secondary rank is higher and not empty use secondary value
    else if( _bRank2Higher && (([NSNumber numberWithFloat:secondaryVal]!= NULL && secondaryVal != 0) || bSecondary))
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
    if (primaryVal.count == 0) {
        return secondaryVal;
    }
    
    if (primaryVal.count >0)
    {
        NSMutableArray *arrUnique = [NSMutableArray new];
        
        [arrUnique addObjectsFromArray:primaryVal];
        
        if (secondaryVal.count >0) {
            
            for( id anthing in secondaryVal )
            {
                if( ![arrUnique containsObject:anthing] )
                    [arrUnique addObject:anthing];
            }
        }
        return arrUnique;
    }
    
    return  nil;
    
    //combine objects from both arrays with no duplicates and return
    
}
-(UIView*)adjustSpaceForMyObject: (UIView*)anyObject
{
    //distance to edge from origin
    int pixelsTilEdge = 692 - ((int)anyObject.frame.origin.y) % 692;
    
    //number of pages object straddles
    int iNumberOfStraddledPages = (pixelsTilEdge + anyObject.frame.size.height) / 692;
    
    if( iNumberOfStraddledPages > 0)
        anyObject.frame = CGRectMake(anyObject.frame.origin.x, anyObject.frame.origin.y + pixelsTilEdge + 150 + (50*iNumberOfStraddledPages-1) , anyObject.frame.size.width, anyObject.frame.size.height);
    
    return anyObject;
}

@end
