//
//  ClientFolder.h
//  DNV
//
//  Created by USI on 1/8/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientFolder : NSObject

@property (nonatomic) NSString *folderPath;
@property (nonatomic) NSString *clientName;
@property (nonatomic) NSArray *contents;

@end
