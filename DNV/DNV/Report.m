//
//  Report.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "Report.h"

@implementation Report

-(id)initWithReport:(NSDictionary *)reportDictionary{
    
    self = [super init];
    
    if(self){
        
        self.summary = [reportDictionary objectForKey:@"summary"];
        self.approvedBy = [reportDictionary objectForKey:@"approvedBy"];
        self.preparedBy = [reportDictionary objectForKey:@"preparedBy"];
        self.projectNum = [reportDictionary objectForKey:@"projectNum"];
        self.conclusion = [reportDictionary objectForKey:@"conclusion"];
        self.methodologyDiagramLocation = [reportDictionary objectForKey:@"methodologyDiagramLocation"];
    }
    
    return self;
}


@end
