//
//  User.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "User.h"

@implementation User

-(id)initWithUserID:(NSString *)userID andPassword:(NSString *)password andInfo:(NSString *)otherInfo{

    self = [super init];
    
    if(self){
        
        self.userID = userID;
        self.password = password;
        self.otherUserInfo = otherInfo;
    }
    
    return self;
}


@end
