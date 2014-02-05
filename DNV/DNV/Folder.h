//
//  Folder.h
//  DNV
//
//  Created by USI on 1/8/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Folder : NSObject

@property (nonatomic) NSString *folderPath;
@property (nonatomic) NSString *name;
@property (nonatomic) NSArray *contents;

@end
