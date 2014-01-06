//
//  UserObject.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject

@property (nonatomic) NSString * userID;
@property (nonatomic) NSString * password;
@property (nonatomic) NSString * otherUserInfo;

-(id)init;

@end
