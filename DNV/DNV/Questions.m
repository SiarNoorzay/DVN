//
//  Questions.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "Questions.h"
#import "Answers.h"

@implementation Questions


-(id)initWithQuestion:(NSDictionary *)questionDictionary{
    self = [super init];
    
    if(self){
        self.isCompleted = [[questionDictionary objectForKey:@"isCompleted"] boolValue];
        self.pointsPossible = [[questionDictionary objectForKey:@"pointsPossible"]floatValue];
        self.pointsAwarded = [[questionDictionary objectForKey:@"pointsAwarded"]floatValue];
        self.questionText = [questionDictionary objectForKey:@"questionText"];
        self.helpText = [questionDictionary objectForKey:@"helpText"];
        self.isApplicable = [[questionDictionary objectForKey:@"isApplicable"] boolValue];
        self.notes = [questionDictionary objectForKey:@"notes"];
        self.needsVerifying = [[questionDictionary objectForKey:@"needsVerifying"] boolValue];
        self.verifyDoneBy = [questionDictionary objectForKey:@"verifyDoneBy"];
        self.attachmentsLocationArray = [questionDictionary objectForKey:@"attachmentsLocationArray"];
        self.imageLocationArray = [questionDictionary objectForKey:@"imageLocationArray"];
        self.questionType = [[questionDictionary objectForKey:@"questionType"] intValue];
        self.isThumbsUp = [[questionDictionary objectForKey:@"isThumbsUp"] boolValue];
        self.isThumbsDown = [[questionDictionary objectForKey:@"isThumbsUp"] boolValue];
        self.pointsNeededForLayered = [[questionDictionary objectForKey:@"pointsNeededForLayered"] floatValue];
        
        
        NSMutableArray *tempArray = [questionDictionary objectForKey:@"Answers"];
        NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:[tempArray count]];
        
        for (int i = 0; i < [tempArray count]; i++) {
            Answers *answer = [[Answers alloc]initWithAnswer:[tempArray objectAtIndex:i]];
            
           // [tempArray replaceObjectAtIndex:i withObject:answer];
            [objectArray addObject:answer];
        }
        self.Answers = objectArray;
        
        
        NSMutableArray *tempArray1 = [questionDictionary objectForKey:@"LayeredQuestions"];
        NSMutableArray *objectArray1 = [NSMutableArray arrayWithCapacity:[tempArray1 count]];
        
        for (int i = 0; i < [tempArray1 count]; i++) {
            Questions *question = [[Questions alloc]initWithQuestion:[tempArray1 objectAtIndex:i]];
            
            // [tempArray replaceObjectAtIndex:i withObject:answer];
            [objectArray1 addObject:question];
        }
        self.layeredQuesions = objectArray1;
        
    }
    return self;
}

@end
