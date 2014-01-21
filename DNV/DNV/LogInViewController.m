//
//  LogInViewController.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "LogInViewController.h"
#import <DropboxSDK/DropboxSDK.h>

#import "Audit.h"
#import "Elements.h"
#import "SubElements.h"
#import "Questions.h"
#import "Answers.h"


@interface LogInViewController ()<DBRestClientDelegate>

@property (nonatomic, readonly) DBRestClient * restClient;

@end

@implementation LogInViewController

//@synthesize arrayOfUsers;

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
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }

    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

//    NSError *error;
//    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleAudit"
//                                                                                  ofType:@"json"]];
//    
//    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
//    
//    NSLog(@"JSON contains:\n%@", [dictionary description]);
//    
//    NSDictionary *theAudit = [dictionary objectForKey:@"Audit"];
//    
//    
//    //use this to access the audit and its components dictionary style
//    Audit *aud = [[Audit alloc]initWithAudit:theAudit];
//    NSLog(@"Audit name: %@", aud.name);
//
//    Elements *ele =  aud.Elements[0];
//    NSLog(@"the first element is:%@", [ele objectForKey:@"name"]);
    
//    SubElements *sub = [[ele objectForKey:@"SubElements"]objectAtIndex:0];
//    NSLog(@"the first SubElements is:%@", [sub objectForKey:@"name"]);
//    
//    Questions *ques = [[sub objectForKey:@"Questions"]objectAtIndex:0];
//    NSLog(@"the first Questions is:%@", [ques objectForKey:@"questionText"]);
//
//    Answers *ans = [[ques objectForKey:@"Answers"]objectAtIndex:0];
//    NSLog(@"the first Answer is:%@", [ans objectForKey:@"answerText"]);
//
    
//    //other way to access the audits components (probably easier this way)
//    Elements *ele2 = [[Elements alloc]initWithElement:aud.Elements[1]];
//    NSLog(@"the second element is %@", ele2.name);
//
//    SubElements *sub2 = [[SubElements alloc]initWithSubElement:ele2.Subelements[0]];
//    NSLog(@"the second SubElement is:%@", sub2.name);
    

//
//    NSString *filename = @"/users.json";
//    _myDirectory = @"users.json";
//    _directoryPath = [NSTemporaryDirectory() stringByAppendingPathComponent:_myDirectory];
//    
//    [[self restClient] loadFile:filename intoPath:_directoryPath];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"usersFromDB.json"];
    _directoryPath = filePath;
    
    [self.restClient loadFile:@"/users.json" intoPath:filePath];
    
    self.dnvDBManager = [DNVDatabaseManagerClass getSharedInstance];
    
    [self.dnvDBManager createUserTable];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.userIDTextField.text = @"";
    self.passwordTextField.text = @"";
    
}


- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath
       contentType:(NSString*)contentType metadata:(DBMetadata*)metadata {
    
    NSLog(@"File loaded into path: %@", localPath);
    [self getUserArray];
    
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    NSLog(@"There was an error loading the file - %@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getUserArray{
    if (_directoryPath) { // check if file exists - if so load it:
        NSError *error;
        
        NSString *stringData = [NSString stringWithContentsOfFile:_directoryPath encoding:NSUTF8StringEncoding error:&error];
        NSData *data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
        NSLog(@"JSON contains:\n%@", [dictionary description]);
//        
//        
//        NSDictionary *dictionary1 = [NSDictionary dictionaryWithContentsOfFile:_directoryPath];
//        NSLog(@"JSON1 contains:\n%@", [dictionary1 description]);
//        
//        
//        NSData *data2 = [NSData dataWithContentsOfFile:_directoryPath];
//        NSDictionary *dictionary2 = [NSJSONSerialization JSONObjectWithData: data2 options:kNilOptions error:&error];
//        NSLog(@"JSON2 contains:\n%@", [dictionary2 description]);
//        
//        NSData *data3 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"users"                                                                                   ofType:@"json"]];
//        
//        NSArray *dictionary3 = [NSJSONSerialization JSONObjectWithData: data3 options:kNilOptions error:&error];
//        
//        NSLog(@"JSON3 contains:\n%@", [dictionary3 description]);

        self.arrayOfUsers = [dictionary objectForKey:@"Users"];
        
    }
    
}

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordTextField) {
        [textField resignFirstResponder];
        [self attemptToLogin];
        
    } else if (textField == self.userIDTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    return YES;
}

- (IBAction)LogInButton:(UIBarButtonItem *)sender {
    [self attemptToLogin];
}
-(void)attemptToLogin{
    BOOL foundUser = false;
    
    for (User *usr in self.arrayOfUsers) {
        
        [self.dnvDBManager saveUser:usr];
        
        if ([[usr objectForKey:@"userID" ] isEqualToString:self.userIDTextField.text]) {
            
            self.user = usr;
            foundUser = true;
           // break;
        }
    }    
    
    if (foundUser) {
        BOOL passwordCorrect = false;
        
        if ([[self.user objectForKey:@"password" ] isEqualToString:self.passwordTextField.text]) {
            passwordCorrect= true;
            NSLog(@"User name and password correct");
            [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Incorrect Password" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            NSLog(@"Incorrect password");
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"User ID not recognized" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"User ID not recognized");//add alert view here}
    }
    
}

@end
