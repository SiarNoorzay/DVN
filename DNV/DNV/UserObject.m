//
//  UserObject.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "UserObject.h"

@implementation UserObject

-(id)init{
    
    self = [super init];
    
    if(self){
        
        self.userID = [[NSString alloc]init];
        self.password = [[NSString alloc]init];
        self.otherUserInfo = [[NSString alloc]init];
    }
    
    return self;
}

@end
