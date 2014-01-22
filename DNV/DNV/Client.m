//
//  Client.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "Client.h"

@implementation Client


-(id)initWithClient:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if(self){
        
        self.companyName = [dictionary objectForKey:@"companyName"];
        self.division = [dictionary objectForKey:@"division"];
        self.SICNumber = [dictionary objectForKey:@"SICNumber"];
        self.auditedSite = [dictionary objectForKey:@"auditedSite"];
        self.address = [dictionary objectForKey:@"address"];
        self.cityStateProvince = [dictionary objectForKey:@"cityStateProvince"];
        self.country = [dictionary objectForKey:@"country"];
        self.postalCode = [[dictionary objectForKey:@"postalCode"] integerValue];
        self.auditDate = [dictionary objectForKey:@"auditDate"];
        self.auditor = [dictionary objectForKey:@"auditor"];
        self.numEmployees = [[dictionary objectForKey:@"numEmployees"] integerValue];
        self.baselineAudit = [[dictionary objectForKey:@"baselineAudit"] boolValue];
        self.companyName = [dictionary objectForKey:@"companyName"];
                
    }
    
    return self;
}

//Merge two clients
-(Client *)mergeClients:(Client *)primaryClient with:(Client *)secondaryClient
{
    Client *mergedClient = [Client new];
    
    MergeClass *dataMerger = [MergeClass new];
    dataMerger.bRank2Higher = true; // rank2 > rank2;
    
    //bools
    mergedClient.baselineAudit = [dataMerger mergeBool:primaryClient.baselineAudit with:secondaryClient.baselineAudit];
    
    //int
    mergedClient.numEmployees = (NSInteger)[dataMerger mergeInt:(int)primaryClient.numEmployees with:(int)secondaryClient.numEmployees];
    mergedClient.postalCode = (NSInteger)[dataMerger mergeInt:(int)primaryClient.postalCode with:(int)secondaryClient.postalCode];
    
    //string
    mergedClient.companyName = [dataMerger mergeString:primaryClient.companyName with:secondaryClient.companyName];
    mergedClient.division = [dataMerger mergeString:primaryClient.division with:secondaryClient.division];
    mergedClient.SICNumber = [dataMerger mergeString:primaryClient.SICNumber with:secondaryClient.SICNumber];
    mergedClient.auditedSite = [dataMerger mergeString:primaryClient.auditedSite with:secondaryClient.auditedSite];
    mergedClient.address = [dataMerger mergeString:primaryClient.address with:secondaryClient.address];
    mergedClient.cityStateProvince = [dataMerger mergeString:primaryClient.cityStateProvince with:secondaryClient.cityStateProvince];
    mergedClient.country = [dataMerger mergeString:primaryClient.country with:secondaryClient.country];
    mergedClient.auditDate = [dataMerger mergeString:primaryClient.auditDate with:secondaryClient.auditDate];
    mergedClient.auditor = [dataMerger mergeString:primaryClient.auditor with:secondaryClient.auditor];
    
    return  mergedClient;
}

@end
