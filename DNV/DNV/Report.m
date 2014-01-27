//
//  Report.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "Report.h"

@implementation Report

-(id)initWithReport:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if(self){
        
        self.summary = [dictionary objectForKey:@"summary1234"];
        self.preparedBy = [dictionary objectForKey:@"preparedBy"];
        self.approvedBy = [dictionary objectForKey:@"approvedBy"];
        self.projectNum = [dictionary objectForKey:@"projectNum"];
        self.conclusion = [dictionary objectForKey:@"conclusion"];
        self.methodologyDiagramLocation = [dictionary objectForKey:@"methodologyDiagramLocation"];
        self.clientRef = [dictionary objectForKey:@"clientRef"];
        self.executiveSummary = [dictionary objectForKey:@"executiveSummary"];
        self.scoringAssumptions = [dictionary objectForKey:@"scoringAssumptions"];

    }
    
    return self;
}
//Merge two reports
-(Report *)mergeReports:(Report *)primaryReport with:(Report *)secondaryReport
{
    Report *mergedReports = [Report new];
    
    MergeClass *dataMerger = [MergeClass new];
    dataMerger.bRank2Higher = true; // rank2 > rank2;
    
    //string
    mergedReports.summary = [dataMerger mergeString:primaryReport.summary with:secondaryReport.summary];
    mergedReports.preparedBy = [dataMerger mergeString:primaryReport.preparedBy with:secondaryReport.preparedBy];
    mergedReports.approvedBy = [dataMerger mergeString:primaryReport.approvedBy with:secondaryReport.approvedBy];
    mergedReports.projectNum = [dataMerger mergeString:primaryReport.projectNum with:secondaryReport.projectNum];
    mergedReports.conclusion = [dataMerger mergeString:primaryReport.conclusion with:secondaryReport.conclusion];
    mergedReports.methodologyDiagramLocation = [dataMerger mergeString:primaryReport.methodologyDiagramLocation with:secondaryReport.methodologyDiagramLocation];
    
    return  mergedReports;
}


@end
