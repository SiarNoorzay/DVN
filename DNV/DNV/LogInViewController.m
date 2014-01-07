//
//  LogInViewController.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "LogInViewController.h"
#import <DropboxSDK/DropboxSDK.h>

//#import "Audit.h"
//#import "Elements.h"
//#import "SubElements.h"
//#import "Questions.h"
//#import "Answers.h"


@interface LogInViewController ()

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
//    NSError *error;
//    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleAudit"
//                                                                                  ofType:@"json"]];
//    
//    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
//    
//    NSLog(@"JSON contains:\n%@", [dictionary description]);
//    NSDictionary *theAudit = [dictionary objectForKey:@"Audit"];
//    
//    
//    //use this to access the audit and its components dictionary style
//    Audit *aud = [[Audit alloc]initWithAudit:theAudit];
//    NSLog(@"Audit name: %@", aud.name);
//
//    Elements *ele =  aud.Elements[0];
//    NSLog(@"the first element is:%@", [ele objectForKey:@"name"]);
//    
//    SubElements *sub = [[ele objectForKey:@"SubElements"]objectAtIndex:0];
//    NSLog(@"the first SubElements is:%@", [sub objectForKey:@"name"]);
//    
//    Questions *ques = [[sub objectForKey:@"Questions"]objectAtIndex:0];
//    NSLog(@"the first Questions is:%@", [ques objectForKey:@"questionText"]);
//
//    Answers *ans = [[ques objectForKey:@"Answers"]objectAtIndex:0];
//    NSLog(@"the first Answer is:%@", [ans objectForKey:@"answerText"]);
//
//    
//    //other way to access the audits components (probably easier this way)
//    Elements *ele2 = [[Elements alloc]initWithElement:aud.Elements[1]];
//    NSLog(@"the second element is %@", ele2.name);
//    
//    SubElements *sub2 = [[SubElements alloc]initWithSubElement:ele2.Subelements[0]];
//    NSLog(@"the second SubElement is:%@", sub2.name);
//
//
//    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LogInButton:(UIBarButtonItem *)sender {
    
    
}
@end
