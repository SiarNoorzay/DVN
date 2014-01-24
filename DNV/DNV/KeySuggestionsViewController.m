//
//  KeySuggestionsViewController.m
//  DNV
//
//  Created by USI on 1/24/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "KeySuggestionsViewController.h"

@interface KeySuggestionsViewController ()

@end

@implementation KeySuggestionsViewController


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
    //TODO: get audit from DB instead of bundle
    // self.audit = getAuditFromDB with ID from previous selection
    self.thumbsDowndQuestions = [[NSMutableArray alloc]initWithCapacity:1];
    self.positions = [[NSMutableArray alloc]initWithCapacity:1];

    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleCompletedAudit" ofType:@"json"]];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
    
    NSLog(@"JSON contains:\n%@", [dictionary description]);
    
    NSDictionary *theAudit = [dictionary objectForKey:@"Audit"];
    
    self.audit = [[Audit alloc]initWithAudit:theAudit];
    
    for (int i = 0; i< [self.audit.Elements count]; i++) {
        Elements *ele = [self.audit.Elements objectAtIndex:i];
        for (int j = 0; j<[ele.Subelements count];j++) {
            SubElements *subEle = [ele.Subelements objectAtIndex:j];
            for (int k = 0; k < [subEle.Questions count]; k++) {
                Questions *question =[subEle.Questions objectAtIndex:k];
                
                if (question.isThumbsDown) {
                    [self.thumbsDowndQuestions addObject:question.notes];
                    [self.positions addObject:[NSString stringWithFormat:@"%d.%d.%d", i +1, j+1, k+1]];
                }
                if ([question.layeredQuesions count] >0)
                {
                    for (int l = 0; l < [question.layeredQuesions count]; l++)
                    {
                        Questions *subQuestion = [question.layeredQuesions objectAtIndex:l];
                        if (subQuestion.isThumbsDown) {
                            [self.thumbsDowndQuestions addObject:subQuestion.notes];
                            [self.positions addObject:[NSString stringWithFormat:@"%d.%d.%d.%d", i +1, j+1, k+1,l+1]];
                            
                        }
                    }
                }
            }
            
        }
    }//outer most for loop
    
    for (int i = 0; i < [self.thumbsDowndQuestions count]; i++) {
        NSLog(@" %@    %@",[self.positions objectAtIndex:i], [self.thumbsDowndQuestions objectAtIndex:i] );
        
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.thumbsDowndQuestions count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
    
}

    
@end
