//
//  ElementSubelementProfilesViewController.m
//  DNV
//
//  Created by USI on 1/24/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ElementSubelementProfilesViewController.h"
#import "ProfileLabelCell.h"


@interface ElementSubelementProfilesViewController ()

@end

@implementation ElementSubelementProfilesViewController

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
    NSMutableArray *labelArray = [[NSMutableArray alloc]initWithCapacity:1];
    
    //TODO: get audit from DB instead of bundle
    // self.audit = getAuditFromDB with ID from previous selection
    
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleCompletedAudit" ofType:@"json"]];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
    
    NSLog(@"JSON contains:\n%@", [dictionary description]);
    
    NSDictionary *theAudit = [dictionary objectForKey:@"Audit"];
    
    self.audit = [[Audit alloc]initWithAudit:theAudit];
    
    for (int i = 0; i<[self.audit.Elements count]; i++) {
        Elements *ele = [self.audit.Elements objectAtIndex:i];
        [labelArray addObject:[NSString stringWithFormat:@"%d %@",i+1, ele.name]];
        
        for (int j = 0; j<[ele.Subelements count]; j++) {
            SubElements *subEle = [ele.Subelements objectAtIndex:j];
            [labelArray addObject:[NSString stringWithFormat:@"\t%d.%d %@",i+1,j+1, subEle.name]];
            NSMutableArray *upArray = [[NSMutableArray alloc]initWithCapacity:1];
            NSMutableArray *downArray = [[NSMutableArray alloc]initWithCapacity:1];
        
            for (int k = 0; k<[subEle.Questions count]; k++) {
                Questions *question = [subEle.Questions objectAtIndex:k];
                
                if (question.isThumbsUp) {
                    [upArray addObject: [NSString stringWithFormat:@"\t\t\t%d.%d.%d %@",i+1,j+1,k+1, question.notes]];
                }
                if (question.isThumbsDown) {
                    [downArray addObject: [NSString stringWithFormat:@"\t\t\t%d.%d.%d %@",i+1,j+1,k+1, question.notes]];
                }
                if ([question.layeredQuesions count] >0) {
                    for (int l = 0; l<[question.layeredQuesions count]; l++) {
                        if (question.isThumbsUp) {
                            [upArray addObject: [NSString stringWithFormat:@"\t\t\t\t%d.%d.%d.%d %@",i+1,j+1,k+1,l+1, question.notes]];
                        }
                        if (question.isThumbsDown) {
                            [downArray addObject: [NSString stringWithFormat:@"\t\t\t\t\t%d.%d.%d.%d %@",i+1,j+1,k+1,l+1, question.notes]];
                        }
                    }
                }
                
                if ([upArray count]>0)
                {
                    [labelArray addObject:[NSString stringWithFormat:@"\t\tNoteworthy Efforts"]];
                    for (NSString *ups in upArray)
                    {
                        [labelArray addObject:ups];
                    }
                    
                }
                if ([downArray count]>0)
                {
                    [labelArray addObject:[NSString stringWithFormat:@"\t\tSuggesstions for Improvement "]];
                    for (NSString *downs in downArray)
                    {
                        [labelArray addObject:downs];
                    }
                    
                }
            }
        }
    }
    for (NSString *str in labelArray) {
        NSLog(@"%@",str);
    }
    self.cellArrary = labelArray;
    
    [self.resultsTableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"ProfileLabelCell";
    
    ProfileLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[ProfileLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.cellLabel.text = [self.cellArrary objectAtIndex:indexPath.row];
    
    return cell;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cellArrary count];
    
}

@end
