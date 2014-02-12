//
//  AppDelegate.h
//  DNV
//
//  Created by USI on 12/30/13.
//  Copyright (c) 2013 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
