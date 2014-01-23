//
//  Elements.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "Elements.h"

@implementation Elements


-(id)initWithElement:(NSDictionary *)elementDictionary{
    
    self = [super init];
    
    if(self){
        
        self.isCompleted = [[elementDictionary objectForKey:@"isCompleted"] boolValue];
        self.name = [elementDictionary objectForKey:@"name"];
        self.isRequired = [[elementDictionary objectForKey:@"elementDictionary"]boolValue];
        self.pointsPossible = [[elementDictionary objectForKey:@"pointsPossible"]floatValue];
        self.pointsAwarded = [[elementDictionary objectForKey:@"pointsAwarded"]floatValue];
        
        self.modefiedNAPoints = [[elementDictionary objectForKey:@"modefiedNAPoints"]floatValue];

        NSMutableArray *tempArray = [elementDictionary objectForKey:@"SubElements"];
        NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:[tempArray count]];

        for (int i = 0; i < [tempArray count]; i++) {
            SubElements *subEle = [[SubElements alloc]initWithSubElement:[tempArray objectAtIndex:i]];
            
            [objectArray addObject:subEle];
            
       //     [tempArray replaceObjectAtIndex:i withObject:subEle];
        }
        self.Subelements = objectArray;
        
        
        
        
    }
    return self;
}

//Merge two elements
-(Elements *)mergeElements:(Elements *)primaryElements with:(Elements *)secondaryElements
{
    Elements *mergedElements = [Elements new];
    
    MergeClass *dataMerger = [MergeClass new];
    dataMerger.bRank2Higher = true; // rank2 > rank2;
    
    //bools
    mergedElements.isCompleted = [dataMerger mergeBool:primaryElements.isCompleted with:secondaryElements.isCompleted];
    mergedElements.isRequired = [dataMerger mergeBool:primaryElements.isRequired with:secondaryElements.isRequired];
    
    //float
    mergedElements.pointsPossible = [dataMerger mergeFloat:primaryElements.pointsPossible with:secondaryElements.pointsPossible];
    mergedElements.pointsAwarded = [dataMerger mergeFloat:primaryElements.pointsAwarded with:secondaryElements.pointsAwarded];
    mergedElements.modefiedNAPoints = [dataMerger mergeFloat:primaryElements.modefiedNAPoints with:secondaryElements.modefiedNAPoints];
    
    //string
    mergedElements.name = [dataMerger mergeString:primaryElements.name with:secondaryElements.name];
    
    //questions array
    NSMutableArray *mergedSubElements = [NSMutableArray new];
    SubElements *someSubElement = [SubElements new];
    for( int i = 0; i < [primaryElements.Subelements count]; i++ )
    {
        [mergedSubElements addObject:[someSubElement mergeSubElements:[primaryElements.Subelements objectAtIndex:i] with:[secondaryElements.Subelements objectAtIndex:i]]];
    }
    
    mergedElements.Subelements = [NSArray arrayWithArray:mergedSubElements];
    
    return  mergedElements;
}

@end

