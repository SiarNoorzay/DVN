//
//  AuditIDObject.m
//  DNV
//
//  Created by USI on 1/22/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "AuditIDObject.h"

@implementation AuditIDObject

-(id)initWithID:(int)ID name:(NSString *)name{
    
    self = [super init];
    
    if (self){
        
        self.auditID = ID;
        self.auditName = name;
        
    }
    
    return self;
}

@end
