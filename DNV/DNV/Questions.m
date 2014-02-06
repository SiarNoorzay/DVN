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
        
        self.questionID = [[questionDictionary objectForKey:@"questionID"] integerValue];
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
        
        NSMutableArray *physicalArray = [questionDictionary objectForKey:@"PhysicalObservations"];
        NSMutableArray *interviewArray = [questionDictionary objectForKey:@"InterviewObservations"];
        NSMutableArray *recordsArray = [questionDictionary objectForKey:@"Records"];
        
        NSMutableArray *aTempArray = [NSMutableArray new];
        for( int i = 0; i < [physicalArray count]; i++)
        {
            Observations *pObs = [[Observations alloc] initWithObservation:[physicalArray objectAtIndex:i]];
            [aTempArray addObject:pObs];
        }
        self.PhysicalObservations = aTempArray;
        
        NSMutableArray *bTempArray = [NSMutableArray new];
        for( int i = 0; i < [interviewArray count]; i++)
        {
            Observations *iObs = [[Observations alloc] initWithObservation:[interviewArray objectAtIndex:i]];
            [bTempArray addObject:iObs];
        }
        self.InterviewObservations = bTempArray;
                             
        NSMutableArray *cTempArray = [NSMutableArray new];
        for( int i = 0; i < [recordsArray count]; i++)
        {
            Records *rObj = [[Records alloc] initWithRecord:[recordsArray objectAtIndex:i]];
            [cTempArray addObject:rObj];
        }
        self.Records = cTempArray;
                                                  
                                                  
        
        NSMutableArray *tempArray = [questionDictionary objectForKey:@"Answers"];
        NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:[tempArray count]];
        
        for (int i = 0; i < [tempArray count]; i++) {
            Answers *answer = [[Answers alloc]initWithAnswer:[tempArray objectAtIndex:i]];
            
           // [tempArray replaceObjectAtIndex:i withObject:answer];
            [objectArray addObject:answer];
        }
        self.Answers = objectArray;
        
        
        NSMutableArray *tempArray1 = [questionDictionary objectForKey:@"layeredQuestions"];
        NSMutableArray *objectArray1 = [NSMutableArray arrayWithCapacity:[tempArray1 count]];
        
        for (int i = 0; i < [tempArray1 count]; i++) {
            Questions *question = [[Questions alloc]initWithQuestion:[tempArray1 objectAtIndex:i]];
            
            // [tempArray replaceObjectAtIndex:i withObject:answer];
            [objectArray1 addObject:question];
        }
        self.layeredQuesions = objectArray1;
        
        self.zeroIfNoPointsFor = [questionDictionary objectForKey:@"zeroIfNoPointsFor"];
        self.lessOrEqualToSmallestAnswer = [questionDictionary objectForKey:@"lessOrEqualToSmallestAnswer"];
        self.drawnNotes = [questionDictionary objectForKey:@"drawnNotes"];

    }
    return self;
}

//Merge two questions
-(Questions *)mergeQuestion:(Questions *)primaryQuestion with:(Questions *)secondaryQuestion ofRank:(BOOL)bRank2Higher
{
    Questions *mergedQuestion = [Questions new];
    
    MergeClass *dataMerger = [MergeClass new];
    dataMerger.bRank2Higher = bRank2Higher; // rank2 > rank2;
    
    if( primaryQuestion.isThumbsDown)
    {
        NSLog(@"g");
    }
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
    mergedQuestion.pointsAwarded = [dataMerger mergeFloat:primaryQuestion.pointsAwarded with:secondaryQuestion.pointsAwarded bCompletedPrimary:primaryQuestion.isCompleted bCompletedSecondary:secondaryQuestion.isCompleted];
    mergedQuestion.pointsNeededForLayered = [dataMerger mergeFloat:primaryQuestion.pointsNeededForLayered with:secondaryQuestion.pointsNeededForLayered];
    
    //string
    mergedQuestion.questionText = [dataMerger mergeString:primaryQuestion.questionText with:secondaryQuestion.questionText];
    mergedQuestion.helpText = [dataMerger mergeString:primaryQuestion.helpText with:secondaryQuestion.helpText];
    mergedQuestion.notes = [dataMerger mergeString:primaryQuestion.notes with:secondaryQuestion.notes];
   
    //arrays
    mergedQuestion.attachmentsLocationArray = [dataMerger mergeArray:primaryQuestion.attachmentsLocationArray with:secondaryQuestion.attachmentsLocationArray];
    mergedQuestion.imageLocationArray = [dataMerger mergeArray:primaryQuestion.imageLocationArray with:secondaryQuestion.imageLocationArray];
    mergedQuestion.zeroIfNoPointsFor = [dataMerger mergeArray:primaryQuestion.zeroIfNoPointsFor with:secondaryQuestion.zeroIfNoPointsFor];
    mergedQuestion.lessOrEqualToSmallestAnswer = [dataMerger mergeArray:primaryQuestion.lessOrEqualToSmallestAnswer with:secondaryQuestion.lessOrEqualToSmallestAnswer];
    
    mergedQuestion.PhysicalObservations = [dataMerger mergeArray:primaryQuestion.PhysicalObservations with:secondaryQuestion.PhysicalObservations];
    mergedQuestion.InterviewObservations = [dataMerger mergeArray:primaryQuestion.InterviewObservations with:secondaryQuestion.InterviewObservations];
    mergedQuestion.Records = [dataMerger mergeArray:primaryQuestion.Records with:secondaryQuestion.Records];
    
    
    
    //answer array
    NSMutableArray *mergedAnswers = [NSMutableArray new];
    Answers *someAnswer = [Answers new];
    for( int i = 0; i < [primaryQuestion.Answers count]; i++ )
    {
        [mergedAnswers addObject:[someAnswer mergeAnswer:[primaryQuestion.Answers objectAtIndex:i] with:[secondaryQuestion.Answers objectAtIndex:i] ofRank:dataMerger.bRank2Higher]];
    }
    mergedQuestion.Answers = [NSArray arrayWithArray:mergedAnswers];
    
    
    
//    //phisycial observation array
//    NSMutableArray *mergedPhysicalObs = [NSMutableArray new];
//    Observations *someObservation = [Observations new];
//    for( int i = 0; i < [primaryQuestion.PhysicalObservations count]; i++ )
//    {
//        [mergedPhysicalObs addObject:[someObservation mergeObservations:[primaryQuestion.PhysicalObservations objectAtIndex:i] with:[secondaryQuestion.PhysicalObservations objectAtIndex:i] ofRank:dataMerger.bRank2Higher]];
//    }
//    mergedQuestion.PhysicalObservations = [NSArray arrayWithArray:mergedPhysicalObs];
//    
//    //interview observation array
//    NSMutableArray *mergedInterviewObs = [NSMutableArray new];
//    for( int i = 0; i < [primaryQuestion.InterviewObservations count]; i++ )
//    {
//        [mergedInterviewObs addObject:[someObservation mergeObservations:[primaryQuestion.InterviewObservations objectAtIndex:i] with:[secondaryQuestion.InterviewObservations objectAtIndex:i] ofRank:dataMerger.bRank2Higher]];
//    }
//    mergedQuestion.InterviewObservations = [NSArray arrayWithArray:mergedInterviewObs];
//    
//    //records array
//    NSMutableArray *mergedRecords = [NSMutableArray new];
//    Records *someRecord = [Records new];
//    for( int i = 0; i < [primaryQuestion.Records count]; i++ )
//    {
//        [mergedRecords addObject:[someRecord mergeRecords:[primaryQuestion.Records objectAtIndex:i] with:[secondaryQuestion.Records objectAtIndex:i] ofRank:dataMerger.bRank2Higher]];
//    }
//    mergedQuestion.Records = [NSArray arrayWithArray:mergedRecords];
    
    
    
    
    //layered questions array
    NSMutableArray *mergedLayeredQuestions = [NSMutableArray new];
    Questions *someQuestion = [Questions new];
    for( int i = 0; i < [primaryQuestion.layeredQuesions count]; i++ )
    {
        [mergedLayeredQuestions addObject:[someQuestion mergeQuestion:primaryQuestion.layeredQuesions[i] with:secondaryQuestion.layeredQuesions[i] ofRank:bRank2Higher]];
    }
    mergedQuestion.layeredQuesions = [NSArray arrayWithArray:mergedLayeredQuestions];
    
    return  mergedQuestion;
}

//@property (nonatomic) NSArray * Answers;//@property (nonatomic) NSArray * layeredQuesions;


-(NSDictionary*)toDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:20];
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.questionID] forKey:@"questionID"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.isCompleted] forKey:@"isCompleted"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%f", self.pointsPossible] forKey:@"pointsPossible"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%f", self.pointsAwarded] forKey:@"pointsAwarded"];
    
    [dictionary setValue:self.questionText forKey:@"questionText"];

    [dictionary setValue:self.helpText forKey:@"helpText"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.isApplicable] forKey:@"isApplicable"];
    
    [dictionary setValue:self.notes forKey:@"notes"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.needsVerifying] forKey:@"needsVerifying"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.isVerifyDone] forKey:@"isVerifyDone"];
    
    [dictionary setValue:self.attachmentsLocationArray forKey:@"attachmentsLocationArray"];
    
    [dictionary setValue:self.imageLocationArray forKey:@"imageLocationArray"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.questionType] forKey:@"questionType"];

    [dictionary setValue:[NSString stringWithFormat:@"%d", self.isThumbsUp] forKey:@"isThumbsUp"];

    [dictionary setValue:[NSString stringWithFormat:@"%d", self.isThumbsDown] forKey:@"isThumbsDown"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%f", self.pointsNeededForLayered] forKey:@"pointsNeededForLayered"];
    
    NSMutableArray *ansArray = [NSMutableArray new];
    for (Answers *answer in self.Answers) {
        [ansArray addObject: [answer toDictionary]];
    }
    [dictionary setValue:ansArray forKey:@"Answers"];
    
    
    NSMutableArray *layeredQuestions = [NSMutableArray new];
    for (Questions *layQuest in self.layeredQuesions) {
        [layeredQuestions addObject: [layQuest toDictionary]];
    }
    [dictionary setValue:layeredQuestions forKey:@"layeredQuestions"];
    
    
    [dictionary setValue:self.zeroIfNoPointsFor forKey:@"zeroIfNoPointsFor"];
    
    [dictionary setValue:self.lessOrEqualToSmallestAnswer forKey:@"lessOrEqualToSmallestAnswer"];

    [dictionary setValue:self.drawnNotes forKey:@"drawnNotes"];

    
    return dictionary;
    
    
}

@end
