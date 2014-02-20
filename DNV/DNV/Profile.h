//
//  Profile.h
//  DNV
//
//  Created by USI on 2/19/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Questions.h"

@interface Profile : NSObject

@property (strong, nonatomic) NSString *text;

@property (strong, nonatomic) Questions *question;


@end
