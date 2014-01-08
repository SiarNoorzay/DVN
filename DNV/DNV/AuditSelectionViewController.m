//
//  AuditSelectionViewController.m
//  DNV
//
//  Created by USI on 1/7/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "AuditSelectionViewController.h"

#import "Elements.h"

@interface AuditSelectionViewController ()

@end

@implementation AuditSelectionViewController

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
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleAudit"
                                                                                  ofType:@"json"]];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
    
    NSLog(@"JSON contains:\n%@", [dictionary description]);
    
    NSDictionary *theAudit = [dictionary objectForKey:@"Audit"];
    
    
    //use this to access the audit and its components dictionary style
    self.aud = [[Audit alloc]initWithAudit:theAudit];
    NSLog(@"Audit name: %@", self.aud.name);
    
    NSLog(@"Number of Elements: %d", [self.aud.Elements count]);
    
//    Elements *ele =  aud.Elements[0];
//    NSLog(@"the first element is:%@", [ele objectForKey:@"name"]);
//    
//    //other way to access the audits components (probably easier this way)
//    Elements *ele2 = [[Elements alloc]initWithElement:aud.Elements[1]];
//    NSLog(@"the second element is %@", ele2.name);
    
    [self.auditListTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"TestCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.aud.name;
//    cell.imageView.image = [UIImage imageNamed:@"check-mark-button.png"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

@end
