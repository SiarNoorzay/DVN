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
        
        self.elementID = [[elementDictionary objectForKey:@"elementID"]integerValue];
        self.isCompleted = [[elementDictionary objectForKey:@"isCompleted"] boolValue];
        self.name = [elementDictionary objectForKey:@"name"];
        self.isRequired = [[elementDictionary objectForKey:@"isRequired"]boolValue];
        
        if ([[elementDictionary allKeys] containsObject:@"pointsPossible"]) {
            
            self.pointsPossible = [[elementDictionary objectForKey:@"pointsPossible"]floatValue];
        }
        else
            self.pointsPossible = -1;
        
        self.pointsAwarded = [[elementDictionary objectForKey:@"pointsAwarded"]floatValue];
        
        self.modefiedNAPoints = [[elementDictionary objectForKey:@"modefiedNAPoints"]floatValue];

        if ([elementDictionary objectForKey:@"isApplicable"] == nil) {
            self.isApplicable = true;
        }
        else self.isApplicable = [[elementDictionary objectForKey:@"isApplicable"]boolValue];
        
        NSMutableArray *tempArray = [elementDictionary objectForKey:@"SubElements"];
        NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:[tempArray count]];

        for (int i = 0; i < [tempArray count]; i++) {
            SubElements *subEle = [[SubElements alloc]initWithSubElement:[tempArray objectAtIndex:i]];
            
            [objectArray addObject:subEle];
            
       //     [tempArray replaceObjectAtIndex:i withObject:subEle];
        }
        self.Subelements = objectArray;
        
        self.zeroIfNoPointsFor = [elementDictionary objectForKey:@"zeroIfNoPointsFor"];
    }
    if ([self.zeroIfNoPointsFor count] >0)
    {
        for (SubElements *sub in self.Subelements) {
            if (sub.zeroIfNoPointsFor == nil) {
                sub.zeroIfNoPointsFor = [[NSMutableArray alloc]initWithCapacity:1];
            }
            [sub.zeroIfNoPointsFor addObjectsFromArray:self.zeroIfNoPointsFor];
            
        }
    }
    return self;
}

//Merge two elements
-(Elements *)mergeElements:(Elements *)primaryElements with:(Elements *)secondaryElements ofRank:(BOOL)bRank2Higher
{
    Elements *mergedElements = [Elements new];
    
    MergeClass *dataMerger = [MergeClass new];
    dataMerger.bRank2Higher = bRank2Higher; // rank2 > rank2;
    
    //bools
    mergedElements.isCompleted = [dataMerger mergeBool:primaryElements.isCompleted with:secondaryElements.isCompleted];
    mergedElements.isRequired = [dataMerger mergeBool:primaryElements.isRequired with:secondaryElements.isRequired];
    mergedElements.isApplicable = [dataMerger mergeBool:primaryElements.isApplicable with:secondaryElements.isApplicable];
    
    //float
    mergedElements.pointsPossible = [dataMerger mergeFloat:primaryElements.pointsPossible with:secondaryElements.pointsPossible];
    mergedElements.pointsAwarded = [dataMerger mergeFloat:primaryElements.pointsAwarded with:secondaryElements.pointsAwarded];
    mergedElements.modefiedNAPoints = [dataMerger mergeFloat:primaryElements.modefiedNAPoints with:secondaryElements.modefiedNAPoints];
    
    //string
    mergedElements.name = [dataMerger mergeString:primaryElements.name with:secondaryElements.name];
    
    //array
    mergedElements.zeroIfNoPointsFor = [dataMerger mergeArray:mergedElements.zeroIfNoPointsFor with:mergedElements.zeroIfNoPointsFor];
    
    //subelements array
    NSMutableArray *mergedSubElements = [NSMutableArray new];
    SubElements *someSubElement = [SubElements new];
    for( int i = 0; i < [primaryElements.Subelements count]; i++ )
    {
        [mergedSubElements addObject:[someSubElement mergeSubElements:[primaryElements.Subelements objectAtIndex:i] with:[secondaryElements.Subelements objectAtIndex:i] ofRank:dataMerger.bRank2Higher]];
    }
    
    mergedElements.Subelements = [NSArray arrayWithArray:mergedSubElements];
    
    return  mergedElements;
}
-(NSDictionary*)toDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:9];
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.elementID] forKey:@"elementID"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.isCompleted] forKey:@"isCompleted"];
    
    [dictionary setValue:self.name forKey:@"name"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.isRequired] forKey:@"isRequired"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%f", self.pointsPossible] forKey:@"pointsPossible"];

    [dictionary setValue:[NSString stringWithFormat:@"%f", self.pointsAwarded] forKey:@"pointsAwarded"];
    
    
    NSMutableArray *subEleArray = [NSMutableArray new];
    for (SubElements *subEle in self.Subelements) {
        [subEleArray addObject: [subEle toDictionary]];
    }
    [dictionary setValue:subEleArray forKey:@"SubElements"];
    
    
    [dictionary setValue:[NSString stringWithFormat:@"%f", self.modefiedNAPoints] forKey:@"modefiedNAPoints"];

    [dictionary setValue:self.zeroIfNoPointsFor forKey:@"zeroIfNoPointsFor"];
    
    
    return dictionary;
}

@end

