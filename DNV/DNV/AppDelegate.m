//
//  AppDelegate.m
//  DNV
//
//  Created by USI on 12/30/13.
//  Copyright (c) 2013 USI. All rights reserved.
//

#import "AppDelegate.h"
#import <DropboxSDK/DropboxSDK.h>
#import "LogInViewController.h"
#import "Flurry.h"


@implementation AppDelegate

{
    NSString *pathOfFile;
    NSString *tempURL;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    DBSession* dbSession =
    [[DBSession alloc]
      initWithAppKey:@"u91hg98nvmqeb8g"
      appSecret:@"qqqibbo71cmc70d"
      root:kDBRootDropbox]; // either kDBRootAppFolder or kDBRootDropbox... INTERESTINGLY ON IPAD ONLY ROOTDROPBOX WORKS
    
    [DBSession setSharedSession:dbSession];
    
    
    [Flurry setCrashReportingEnabled:YES];
    //note: iOS only allows one crash reporting tool per app; if using another, set to: NO
    [Flurry startSession:@"JXPCVN7MYZTH7P8QVNJK"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    NSLog(@"Testing");
//    
//    if ([[DBSession sharedSession] isLinked]) {
//        [[DBSession sharedSession] unlinkAll];
//        [[[UIAlertView alloc]
//          initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked"
//          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
//         show];
//    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
}







- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (url != nil && [url isFileURL])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Download data
            tempURL = [url absoluteString];
            
            NSData *currData = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempURL]];
            
            
            NSRange range = [tempURL rangeOfString:@"Inbox/"];
            tempURL = [tempURL substringFromIndex:range.location+7];
            
            // Create file at path
            NSFileManager *fileManager = [NSFileManager new];
            NSError *error = [NSError new];
            
            NSString *dataPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Attachments"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
                [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
            
            
            [fileManager createFileAtPath:[NSString stringWithFormat:@"%@/%@", dataPath, tempURL] contents:currData attributes:nil];
            
            AppDelegate *tmpDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UIViewController *myCurrentController = ((UINavigationController*)tmpDelegate.window.rootViewController).visibleViewController;
            
            //Present opened in file through QLPreviewController
            @try
            {
                QLPreviewController * preview = [[QLPreviewController alloc] init];
                preview.dataSource = self;
                [myCurrentController presentViewController:preview animated:YES completion:nil];
            }
            @catch (NSException *exception)
            {
                //nslog(@"Exception caught: %@", exception);
            }
        });
    }
    
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        
        UINavigationController *theNav = (UINavigationController *)[self.window rootViewController];
        LogInViewController *loginVC = (LogInViewController*)[theNav topViewController];
        
        if ([[DBSession sharedSession] isLinked])
        {
            NSLog(@"App linked successfully!");
            
            loginVC.showAlert = true;
            
            // At this point you can start making API calls
            [loginVC.restClient loadAccountInfo];
            
            [loginVC pingUserJsonSetUpTables];
        }
        else
        {
            [loginVC.btnSetDropBox setTitle:@"Link to Dropbox"];
        }
        //if it fails throw error?
    }

    return YES;
}


//// Quick Look methods, delegates and data sources...
#pragma mark QLPreviewControllerDelegate methods
- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item {
	
	return YES;
}


#pragma mark QLPreviewControllerDataSource methods
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller {
	
    return 1;
}

- (id <QLPreviewItem>) previewController: (QLPreviewController *) controller previewItemAtIndex: (NSInteger) index
{
    NSString *dataPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Attachments"];
    
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",dataPath, tempURL]];
}
////

@end
