//
//  Audit.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "Audit.h"

@implementation Audit



-(id)initWithAudit:(NSDictionary *)auditDictionary{
    
    self = [super init];
    
    if(self){
        self.auditID = [auditDictionary objectForKey:@"auditID"];
        self.auditType = [[auditDictionary objectForKey:@"auditType"] integerValue];
        self.name = [auditDictionary objectForKey:@"name"];
       // self.physicalConditionScore = [[auditDictionary objectForKey:@"physicalConditionScore"]floatValue];
        self.lastModefied = [auditDictionary objectForKey:@"lastModified"];
        self.report = [[Report alloc ]initWithReport:[auditDictionary objectForKey:@"Report"]];
        self.client = [[Client alloc] initWithClient:[auditDictionary objectForKey:@"Client"]];
    
        NSMutableArray *tempArray = [auditDictionary objectForKey:@"Elements"];
        NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:[tempArray count]];

        
        for (int i = 0; i < [tempArray count]; i++) {
            Elements *ele = [[Elements alloc]initWithElement:[tempArray objectAtIndex:i]];
            
            [objectArray addObject:ele];
        //    [tempArray replaceObjectAtIndex:i withObject:ele];
            
        }
        self.Elements = objectArray;

    }
    
    return self;
}

//Merge two audits
-(Audit*)mergeAudit:(Audit*)primaryAudit with:(Audit*)secondaryAudit
{
    Audit *mergedAudits = [Audit new];
    
    MergeClass *dataMerger = [MergeClass new];
    dataMerger.bRank2Higher = true; // rank2 > rank2;
    
    //int
    mergedAudits.auditType = (NSInteger)[dataMerger mergeInt:(int)primaryAudit.auditType with:(int)secondaryAudit.auditType];
    
    //float
  //  mergedAudits.physicalConditionScore = [dataMerger mergeFloat:primaryAudit.physicalConditionScore with:secondaryAudit.physicalConditionScore];
    
    //string
    mergedAudits.name = [dataMerger mergeString:primaryAudit.name with:secondaryAudit.name];
    mergedAudits.lastModefied = [dataMerger mergeString:primaryAudit.lastModefied with:secondaryAudit.lastModefied];
    
    //report
    Report *aReport = [Report new];
    mergedAudits.report = [aReport mergeReports:primaryAudit.report with:secondaryAudit.report ];
    
    //client
    Client *aClient = [Client new];
    mergedAudits.client = [aClient mergeClients:primaryAudit.client with:secondaryAudit.client ];
    
    
    //elements array
    NSMutableArray *mergedElements = [NSMutableArray new];
    Elements *someElement = [Elements new];
    for( int i = 0; i < [primaryAudit.Elements count]; i++ )
    {
        [mergedElements addObject:[someElement mergeElements:[primaryAudit.Elements objectAtIndex:i] with:[secondaryAudit.Elements objectAtIndex:i]]];
    }
    
    mergedAudits.Elements = [NSArray arrayWithArray:mergedElements];
    
    return  mergedAudits;
}
-(NSDictionary*)toDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:7];
    
    [dictionary setValue:self.auditID forKey:@"auditID"];
    
    NSString *tempAuditType = [NSString stringWithFormat:@"%d",self.auditType];
    [dictionary setValue:tempAuditType forKey:@"auditType"];
    
    [dictionary setValue:self.name forKey:@"name"];

    NSMutableArray *eleArray = [NSMutableArray new];
    for (Elements *ele in self.Elements) {
        [eleArray addObject: [ele toDictionary]];
    }
    [dictionary setValue:eleArray forKey:@"Elements"];
    
    [dictionary setValue:self.lastModefied forKey:@"lastModified"];

    [dictionary setValue:[self.report toDictionary] forKey:@"Report"];

    [dictionary setValue:[self.client toDictionary] forKey:@"Client"];

    return dictionary;

}

@end
