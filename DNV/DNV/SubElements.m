//
//  SubElements.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "SubElements.h"
#import "Questions.h"

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
        
        NSMutableArray *tempArray = [subElementDictionary objectForKey:@"Questions"];
        NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:[tempArray count]];


        
        for (int i = 0; i < [tempArray count]; i++) {
            Questions *question = [[Questions alloc]initWithQuestion:[tempArray objectAtIndex:i]];
            
            [objectArray addObject:question];

            //[tempArray replaceObjectAtIndex:i withObject:question];
            
        }
        self.Questions = tempArray;
        
        
        
        
    }
    return self;
}


@end
