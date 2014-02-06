//
//  Observations.m
//  DNV
//
//  Created by Jaime Martinez on 2/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "Observations.h"

@implementation Observations

-(id)initWithObservation:(NSDictionary *)observationDictionary
{
    
    
    self = [super init];
    
    if(self){
                
        self.description = [observationDictionary objectForKey:@"description"];
        self.confirmedCount = [[observationDictionary objectForKey:@"confirmedCount"] intValue];
        self.notConfirmedCount = [[observationDictionary objectForKey:@"notConfirmedCount"]intValue];
        self.percentComplete = [[observationDictionary objectForKey:@"percentComplete"] floatValue];
        
    }
    return self;
    
}

//Merge two answers
-(Observations *)mergeObservations:(Observations *)primaryObservations with:(Observations *)secondaryObservations ofRank:(BOOL)bRank2Higher
{
    Observations *mergedObservation = [Observations new];
    
    MergeClass *dataMerger = [MergeClass new];
    dataMerger.bRank2Higher = bRank2Higher; // rank2 > rank2;
    
    
    //string
    mergedObservation.description = [dataMerger mergeString:primaryObservations.description with:secondaryObservations.description];
    
    //int
    mergedObservation.confirmedCount = [dataMerger mergeInt:primaryObservations.confirmedCount  with:secondaryObservations.confirmedCount ];
    mergedObservation.notConfirmedCount = [dataMerger mergeInt:primaryObservations.notConfirmedCount  with:secondaryObservations.notConfirmedCount ];
    
    //float
    mergedObservation.percentComplete = [dataMerger mergeFloat:primaryObservations.percentComplete  with:secondaryObservations.percentComplete ];
    
    //bool
   // mergedAnswer.isSelected = [dataMerger mergeBool:primaryObservations.isSelected with:secondaryObservations.isSelected];
    
    return  mergedObservation;
}

-(NSDictionary*)toDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    
    [dictionary setValue:self.description forKey:@"description"];
    
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.confirmedCount] forKey:@"confirmedCount"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.notConfirmedCount] forKey:@"notConfirmedCount"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%f", self.percentComplete] forKey:@"percentComplete"];
    
    
    return dictionary;
    
}


@end
