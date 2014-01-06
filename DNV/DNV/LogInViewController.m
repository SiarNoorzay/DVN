//
//  LogInViewController.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "LogInViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface LogInViewController ()<DBRestClientDelegate>

@property (nonatomic, readonly) DBRestClient * restClient;

@end

@implementation LogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    
//    NSString *localPath = [[NSBundle mainBundle] pathForResource:@"Users" ofType:@"json"];
    
    NSString *filename = @"/Users/users.json";
    _myDirectory = @"users.json";
    _directoryPath = [NSTemporaryDirectory() stringByAppendingPathComponent:_myDirectory];
    
    [[self restClient] loadFile:filename intoPath:_directoryPath];
    
    
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath
       contentType:(NSString*)contentType metadata:(DBMetadata*)metadata {
    
    NSLog(@"File loaded into path: %@", localPath);
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    NSLog(@"There was an error loading the file - %@", error);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

- (IBAction)LogInButton:(UIBarButtonItem *)sender {
    
    
    
}
@end
