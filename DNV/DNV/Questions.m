//
//  Questions.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "Questions.h"

@implementation Questions



-(id)initWithQuestion:(NSDictionary *)questionDictionary{
    self = [super init];
    
    if(self){
        self.isCompleted = [[questionDictionary objectForKey:@"isCompleted"] boolValue];
        self.pointsPossible = [[questionDictionary objectForKey:@"pointsPossible"]floatValue];
        self.pointsAwarded = [[questionDictionary objectForKey:@"pointsAwarded"]floatValue];
        self.questionText = [questionDictionary objectForKey:@"questionText"];
        self.helpText = [questionDictionary objectForKey:@"helpText"];
        
        if ([questionDictionary objectForKey:@"isApplicable"] == nil) {
            self.isApplicable = true;
        }
        else self.isApplicable = [[questionDictionary objectForKey:@"isApplicable"]boolValue];
        
        self.notes = [questionDictionary objectForKey:@"notes"];
        self.needsVerifying = [[questionDictionary objectForKey:@"needsVerifying"] integerValue];
        self.isVerifyDone = [[questionDictionary objectForKey:@"isVerifyDone"] boolValue];
        self.attachmentsLocationArray = [questionDictionary objectForKey:@"attachmentsLocationArray"];
        self.imageLocationArray = [questionDictionary objectForKey:@"imageLocationArray"];
        self.questionType = [[questionDictionary objectForKey:@"questionType"] intValue];
        self.isThumbsUp = [[questionDictionary objectForKey:@"isThumbsUp"] boolValue];
        self.isThumbsDown = [[questionDictionary objectForKey:@"isThumbsDown"] boolValue];
        self.pointsNeededForLayered = [[questionDictionary objectForKey:@"pointsNeededForLayered"] floatValue];
        //TODO: add isVerfiedDone
        
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

//Merge two questions
-(Questions *)mergeQuestion:(Questions *)primaryQuestion with:(Questions *)secondaryQuestion
{
    Questions *mergedQuestion = [Questions new];
    
    MergeClass *dataMerger = [MergeClass new];
    dataMerger.bRank2Higher = true; // rank2 > rank2;
    
    //bools
    mergedQuestion.isCompleted = [dataMerger mergeBool:primaryQuestion.isCompleted with:secondaryQuestion.isCompleted];
    mergedQuestion.isApplicable = [dataMerger mergeBool:primaryQuestion.isApplicable with:secondaryQuestion.isApplicable];
    mergedQuestion.needsVerifying = [dataMerger mergeBool:primaryQuestion.needsVerifying with:secondaryQuestion.needsVerifying];
    mergedQuestion.isThumbsUp = [dataMerger mergeBool:primaryQuestion.isThumbsUp with:secondaryQuestion.isThumbsUp];
    mergedQuestion.isThumbsDown = [dataMerger mergeBool:primaryQuestion.isThumbsDown with:secondaryQuestion.isThumbsDown];
    
    //int
    mergedQuestion.questionType = [dataMerger mergeInt:primaryQuestion.questionType with:secondaryQuestion.questionType];
    
    //float
    mergedQuestion.pointsPossible = [dataMerger mergeFloat:primaryQuestion.pointsPossible with:secondaryQuestion.pointsPossible];
    mergedQuestion.pointsAwarded = [dataMerger mergeFloat:primaryQuestion.pointsAwarded with:secondaryQuestion.pointsAwarded];
    mergedQuestion.pointsNeededForLayered = [dataMerger mergeFloat:primaryQuestion.pointsNeededForLayered with:secondaryQuestion.pointsNeededForLayered];
    
    //string
    mergedQuestion.questionText = [dataMerger mergeString:primaryQuestion.questionText with:secondaryQuestion.questionText];
    mergedQuestion.helpText = [dataMerger mergeString:primaryQuestion.helpText with:secondaryQuestion.helpText];
    mergedQuestion.notes = [dataMerger mergeString:primaryQuestion.notes with:secondaryQuestion.notes];
   
    //arrays
    mergedQuestion.attachmentsLocationArray = [dataMerger mergeArray:primaryQuestion.attachmentsLocationArray with:secondaryQuestion.attachmentsLocationArray];
    mergedQuestion.imageLocationArray = [dataMerger mergeArray:primaryQuestion.imageLocationArray with:secondaryQuestion.imageLocationArray];
    
    //answer array
    NSMutableArray *mergedAnswers = [NSMutableArray new];
    Answers *someAnswer = [Answers new];
    for( int i = 0; i < [primaryQuestion.Answers count]; i++ )
    {
        [mergedAnswers addObject:[someAnswer mergeAnswer:[primaryQuestion.Answers objectAtIndex:i] with:[secondaryQuestion.Answers objectAtIndex:i]]];
    }
    
    mergedQuestion.Answers = [NSArray arrayWithArray:mergedAnswers];
    
    return  mergedQuestion;
}

//@property (nonatomic) NSArray * Answers;//@property (nonatomic) NSArray * layeredQuesions;


@end
