//
//  SummaryOfRatingsViewController.m
//  DNV
//
//  Created by USI on 1/21/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "SummaryOfRatingsViewController.h"
#import "ElementRatingsCell.h"
#import "Elements.h"
#import "SubElements.h"
#import "Questions.h"
#import "ReportDocViewController.h"

@interface SummaryOfRatingsViewController ()

@end

@implementation SummaryOfRatingsViewController

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
    

    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleCompletedAudit" ofType:@"json"]];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
    
    NSLog(@"JSON contains:\n%@", [dictionary description]);
    
    NSDictionary *theAudit = [dictionary objectForKey:@"Audit"];
    
    self.audit = [[Audit alloc]initWithAudit:theAudit];
    NSMutableArray *tempArr = [[NSMutableArray alloc]initWithCapacity:[self.audit.Elements count]];
    
    for (Elements *ele in self.audit.Elements) {
        [tempArr addObject:ele];
    }
    self.elementsArray = tempArr;
    
    float tempPointsPossible = 0;
    float tempNAPoints = 0;
    float tempAwarded = 0;
    
    for (int i = 0; i< [self.elementsArray count]; i++) {
        Elements *ele = [[Elements alloc]initWithElement:[self.elementsArray objectAtIndex:i]];
        
        tempPointsPossible += ele.pointsPossible;
        tempNAPoints += ele.modefiedNAPoints;
        tempAwarded += ele.pointsAwarded;
        //TODO: save ele back to DB
    }
    self.totalPossibleLabel.text = [NSString stringWithFormat:@"%.1f",tempPointsPossible];
    self.totalAwardedLabel.text = [NSString stringWithFormat:@"%.1f",tempAwarded];
    self.totalPercentageLabel.text = [NSString stringWithFormat:@"%.2f",((tempAwarded / tempPointsPossible) *100)];
    
    
    self.evaluatedPossibleLabel.text = [NSString stringWithFormat: @"%.1f",(tempAwarded - tempNAPoints)];
    self.evaluatedAwardedLabel.text = [NSString stringWithFormat:@"%.1f",tempAwarded];
    
    self.evaluatedPercentageLabel.text = [NSString stringWithFormat:@"%.2f",((tempAwarded / (tempAwarded - tempNAPoints)) *100)];
    
    
    
    
}
#pragma mark - TableView Delegates

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"ElementsRatingsCell";
    
    ElementRatingsCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[ElementRatingsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Elements *element = [[Elements alloc]initWithElement:[self.elementsArray objectAtIndex:indexPath.row]];
    
    cell.elementName.text = element.name;
    if (element.isRequired) {
        cell.required.text = @"R";
    }
    else cell.required.text = @"O";
    
    cell.pointsPossible.text = [NSString stringWithFormat:@"%.1f",element.pointsPossible];
    cell.pointsAwarded.text = [NSString stringWithFormat:@"%.1f",element.pointsAwarded];
    
    cell.percentage.text = [NSString stringWithFormat:@"%.2f %%", (element.pointsAwarded/element.pointsPossible)*100];
    return cell;

    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.elementsArray count];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToReportDocView"]) {
        
        NSLog(@"Going to report doc view");
        // Get destination view
        ReportDocViewController * destVC = [segue destinationViewController];
        
        // Pass the information to your destination view
       [destVC setAudit:self.audit];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
