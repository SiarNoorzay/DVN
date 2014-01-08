//
//  Audit.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "Audit.h"
#import "Elements.h"

@implementation Audit

-(id)initWithAudit:(NSDictionary *)auditDictionary{
    
    self = [super init];
    
    if(self){
    
    /*
     @property (nonatomic) enum auditType;
     @property (nonatomic) NSString * name;
     @property (nonatomic) NSArray * Elements;
     @property (nonatomic) float * physicalConditionScore;
     @property (nonatomic) NSString * awardLevel;
     @property (nonatomic) NSString * lastModefied;
     @property (nonatomic) Report * report;
     */
    
    
        self.auditType = [[auditDictionary objectForKey:@"auditType"] integerValue];
        self.name = [auditDictionary objectForKey:@"name"];
        self.physicalConditionScore = [[auditDictionary objectForKey:@"physicalConditionScore"]floatValue];
        self.awardLevel = [auditDictionary objectForKey:@"awardLevel"];
        self.lastModefied = [auditDictionary objectForKey:@"lastModefied"];
        self.report = [auditDictionary objectForKey:@"Report"];
        self.client = [auditDictionary objectForKey:@"Client"];
    
        NSMutableArray *tempArray = [auditDictionary objectForKey:@"Elements"];
        NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:[tempArray count]];

        
        for (int i = 0; i < [tempArray count]; i++) {
            Elements *ele = [[Elements alloc]initWithElement:[tempArray objectAtIndex:i]];
            
            [objectArray addObject:ele];
        //    [tempArray replaceObjectAtIndex:i withObject:ele];
            
        }
        self.Elements = tempArray;

    }
    
    return self;
}


@end
