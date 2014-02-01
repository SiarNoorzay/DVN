//
//  SubElements.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "SubElements.h"

@implementation SubElements
@synthesize isCompleted;
@synthesize name;


-(id)initWithSubElement:(NSDictionary *)subElementDictionary{
    
    self = [super init];
    
    if(self){
        
        
        /*
         @property (nonatomic) BOOL isCompleted;
         @property (nonatomic) NSString * name;
         @property (nonatomic) float  pointsPossible;
         @property (nonatomic) float  pointsAwarded;
         @property (nonatomic) NSArray * Questions;
         */

        self.isCompleted = [[subElementDictionary objectForKey:@"isCompleted"] boolValue];
        self.name = [subElementDictionary objectForKey:@"name"];
        self.pointsPossible = [[subElementDictionary objectForKey:@"pointsPossible"]floatValue];
        self.pointsAwarded = [[subElementDictionary objectForKey:@"pointsAwarded"]floatValue];
        self.modefiedNAPoints = [[subElementDictionary objectForKey:@"modefiedNAPoints"]floatValue];
        
        NSMutableArray *tempArray = [subElementDictionary objectForKey:@"Questions"];
        NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:[tempArray count]];


        
        for (int i = 0; i < [tempArray count]; i++) {
            Questions *question = [[Questions alloc]initWithQuestion:[tempArray objectAtIndex:i]];
            
            [objectArray addObject:question];

            //[tempArray replaceObjectAtIndex:i withObject:question];
            
        }
        self.Questions = objectArray;
        
        self.zeroIfNoPointsFor = [subElementDictionary objectForKey:@"zeroIfNoPointsFor"];
    }
    return self;
}

//Merge two subelements
-(SubElements *)mergeSubElements:(SubElements *)primarySubElements with:(SubElements *)secondarySubElements
{
    SubElements *mergedSubElements = [SubElements new];
    
    MergeClass *dataMerger = [MergeClass new];
    dataMerger.bRank2Higher = true; // rank2 > rank2;
    
    //bools
    mergedSubElements.isCompleted = [dataMerger mergeBool:primarySubElements.isCompleted with:secondarySubElements.isCompleted];
    
    //float
    mergedSubElements.modefiedNAPoints = [dataMerger mergeFloat:primarySubElements.modefiedNAPoints with:secondarySubElements.modefiedNAPoints];
    mergedSubElements.pointsPossible = [dataMerger mergeFloat:primarySubElements.pointsPossible with:secondarySubElements.pointsPossible];
    mergedSubElements.pointsAwarded = [dataMerger mergeFloat:primarySubElements.pointsAwarded with:secondarySubElements.pointsAwarded];
    
    //string
    mergedSubElements.name = [dataMerger mergeString:primarySubElements.name with:secondarySubElements.name];
    
    //array
    mergedSubElements.zeroIfNoPointsFor = [dataMerger mergeArray:primarySubElements.zeroIfNoPointsFor with:secondarySubElements.zeroIfNoPointsFor];
    
    //questions array
    NSMutableArray *mergedQuestions = [NSMutableArray new];
    Questions *someQuestion = [Questions new];
    for( int i = 0; i < [primarySubElements.Questions count]; i++ )
    {
        [mergedQuestions addObject:[someQuestion mergeQuestion:[primarySubElements.Questions objectAtIndex:i] with:[secondarySubElements.Questions objectAtIndex:i]]];
    }
    
    mergedSubElements.Questions = [NSArray arrayWithArray:mergedQuestions];
    
    return  mergedSubElements;
}

-(NSDictionary*)toDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:8];
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.subElementID] forKey:@"subElementID"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.isCompleted] forKey:@"isCompleted"];
    
    [dictionary setValue:self.name forKey:@"name"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%f", self.pointsPossible] forKey:@"pointsPossible"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%f", self.pointsAwarded] forKey:@"pointsAwarded"];
    
    
    NSMutableArray *questionsArray = [NSMutableArray new];
    for (Questions *quest in self.Questions) {
        [questionsArray addObject: [quest toDictionary]];
    }
    
    [dictionary setValue:questionsArray forKey:@"Questions"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%f", self.modefiedNAPoints] forKey:@"modefiedNAPoints"];
    
    [dictionary setValue:self.zeroIfNoPointsFor forKey:@"zeroIfNoPointsFor"];
    
    
    return dictionary;

    
    
}


@end
