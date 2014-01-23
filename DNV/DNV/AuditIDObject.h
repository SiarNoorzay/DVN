//
//  AuditIDObject.h
//  DNV
//
//  Created by USI on 1/22/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuditIDObject : NSObject

@property (nonatomic) int auditID;
@property (nonatomic) NSString * auditName;

-(id)initWithID:(int) ID name:(NSString *) name;

@end
