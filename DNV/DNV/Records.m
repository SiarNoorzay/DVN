//
//  Records.m
//  DNV
//
//  Created by Jaime Martinez on 2/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "Records.h"

@implementation Records

-(id)initWithRecord:(NSDictionary *)recordsDictionary
{
    
    
    self = [super init];
    
    if(self){
        
        self.description = [recordsDictionary objectForKey:@"description"];
        self.isConfirmed = [[recordsDictionary objectForKey:@"isConfirmed"] boolValue];
        
    }
    return self;
    
}

//Merge two answers
-(Records *)mergeRecords:(Records *)primaryRecords with:(Records *)secondaryRecords ofRank:(BOOL)bRank2Higher
{
    Records *mergedRecords = [Records new];
    
    MergeClass *dataMerger = [MergeClass new];
    dataMerger.bRank2Higher = bRank2Higher; // rank2 > rank2;
    
    //string
    mergedRecords.description = [dataMerger mergeString:primaryRecords.description with:secondaryRecords.description];

    //bool
    mergedRecords.isConfirmed = [dataMerger mergeBool:primaryRecords.isConfirmed with:secondaryRecords.isConfirmed];
    
    return  mergedRecords;
}

-(NSDictionary*)toDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    
    [dictionary setValue:self.description forKey:@"description"];
    
    [dictionary setValue:[NSString stringWithFormat:@"%d", self.isConfirmed] forKey:@"isSelected"];
    
    return dictionary;
}

@end
