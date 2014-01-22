//
//  Client.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "Client.h"
#import "Audit.h"

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

@end
