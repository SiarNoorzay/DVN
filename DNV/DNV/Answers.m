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
     @property (nonatomic) float pointsPossible;
     @property (nonatomic) BOOL isSelected;
     @property (nonatomic) NSArray * Questions;
     */
    
        self.answerText = [answerDictionary objectForKey:@"answerText"];
        self.pointsPossible = [[answerDictionary objectForKey:@"pointsPossible"]floatValue];
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
        
       // self.Questions = tempArray;

    }
    return self;

}

//Merge two answers
-(Answers *)mergeAnswer:(Answers *)primaryAnswer with:(Answers *)secondaryAnswer ofRank:(BOOL)bRank2Higher
{
    Answers *mergedAnswer = [Answers new];
    
    MergeClass *dataMerger = [MergeClass new];
    dataMerger.bRank2Higher = bRank2Higher; // rank2 > rank2;
    
    //bool
    mergedAnswer.isSelected = [dataMerger mergeBool:primaryAnswer.isSelected with:secondaryAnswer.isSelected];
    
    //float
    mergedAnswer.pointsPossible = [dataMerger mergeFloat:primaryAnswer.pointsPossible with:secondaryAnswer.pointsPossible];
    
    //string
    mergedAnswer.answerText = [dataMerger mergeString:primaryAnswer.answerText with:secondaryAnswer.answerText];
    
    return  mergedAnswer;
}

-(NSDictionary*)toDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.answerID] forKey:@"answerID"];
    
    [dictionary setValue:self.answerText forKey:@"answerText"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%f", self.pointsPossible] forKey:@"pointsPossible"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.isSelected] forKey:@"isSelected"];
    
    return dictionary;
    
}




@end
