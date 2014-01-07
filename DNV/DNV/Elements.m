//
//  Elements.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "Elements.h"
#import "SubElements.h"


@implementation Elements


-(id)initWithElement:(NSDictionary *)elementDictionary{
    
    self = [super init];
    
    if(self){
        
        self.isCompleted = [[elementDictionary objectForKey:@"isCompleted"] boolValue];
        self.name = [elementDictionary objectForKey:@"name"];
        self.isRequired = [[elementDictionary objectForKey:@"elementDictionary"]boolValue];
        self.pointsPossible = [[elementDictionary objectForKey:@"pointsPossible"]floatValue];
        self.pointsAwarded = [[elementDictionary objectForKey:@"pointsAwarded"]floatValue];
        
        NSMutableArray *tempArray = [elementDictionary objectForKey:@"SubElements"];
        NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:[tempArray count]];

        for (int i = 0; i < [tempArray count]; i++) {
            SubElements *subEle = [[SubElements alloc]initWithSubElement:[tempArray objectAtIndex:i]];
            
            [objectArray addObject:subEle];
            
       //     [tempArray replaceObjectAtIndex:i withObject:subEle];
        }
        self.Subelements = tempArray;
        
        
        
        
    }
    return self;
}


@end

