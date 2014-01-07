//
//  Answers.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "Answers.h"
#import "Questions.h"

@implementation Answers


-(id)initWithAnswer:(NSDictionary *)answerDictionary{
    

    self = [super init];

    if(self){
    
    
    /*
     @property (nonatomic) NSString * answerText;
     @property (nonatomic) float pointsPossibleOrMultiplier;
     @property (nonatomic) BOOL isSelected;
     @property (nonatomic) NSArray * Questions;
     */
    
        self.answerText = [answerDictionary objectForKey:@"answerText"];
        self.pointsPossibleOrMultiplier = [[answerDictionary objectForKey:@"pointsPossibleOrMultiplier"]floatValue];
        self.isSelected = [[answerDictionary objectForKey:@"isSelected"] boolValue];
        
        NSMutableArray *tempArray = [answerDictionary objectForKey:@"Questions"];
        NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:[tempArray count]];

        if (tempArray) {
            for (int i = 0; i < [tempArray count]; i++) {
                Questions *question = [[Questions alloc]initWithQuestion:[tempArray objectAtIndex:i]];
                
              //  [tempArray replaceObjectAtIndex:i withObject:question];
                [objectArray addObject:question];

                
             //   [tempArray setObject:question atIndexedSubscript:i];
            }
        }
        
        self.Questions = tempArray;
    
    
    
}
return self;
}
@end
