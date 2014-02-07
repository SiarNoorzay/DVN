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
#import "ScoringAssumptionsViewController.h"



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

    
//    NSError *error;
//    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleCompletedAudit" ofType:@"json"]];
//    
//    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
//    
//    NSLog(@"JSON contains:\n%@", [dictionary description]);
//    
//    NSDictionary *theAudit = [dictionary objectForKey:@"Audit"];
//    
//    self.audit = [[Audit alloc]initWithAudit:theAudit];
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]initWithCapacity:[self.audit.Elements count]];
    
    for (Elements *ele in self.audit.Elements) {
        [tempArr addObject:ele];
    }
    self.elementsArray = tempArr;
    
    float auditPointsPossible = 0;
    float auditNAPoints = 0;
    float auditAwarded = 0;
    
    NSMutableArray *eleNames = [[NSMutableArray alloc]initWithCapacity:[self.elementsArray count]];
    NSMutableArray *percents = [[NSMutableArray alloc]initWithCapacity:[self.elementsArray count]];
    
    
    for (int i = 0; i< [self.elementsArray count]; i++) {
        Elements *ele = [self.elementsArray objectAtIndex:i];
        
        auditPointsPossible += ele.pointsPossible;
        auditNAPoints += ele.modefiedNAPoints;
        auditAwarded += ele.pointsAwarded;
        NSString *eleName = ele.name;
        NSString *percent = [NSString stringWithFormat:@"%.2f",((ele.pointsAwarded / (ele.pointsPossible - ele.modefiedNAPoints)) *100)];
        
        [eleNames addObject:eleName];
        [percents addObject:percent];
        
        //TODO: save ele back to DB
    }
    self.totalPossibleLabel.text = [NSString stringWithFormat:@"%.1f",auditPointsPossible];
    self.totalAwardedLabel.text = [NSString stringWithFormat:@"%.1f",auditAwarded];
    self.totalPercentageLabel.text = [NSString stringWithFormat:@"%.2f %%",((auditAwarded / auditPointsPossible) *100)];
    
    
    self.evaluatedPossibleLabel.text = [NSString stringWithFormat: @"%.1f",(auditPointsPossible - auditNAPoints)];
    self.evaluatedAwardedLabel.text = [NSString stringWithFormat:@"%.1f",auditAwarded];
    
    self.evaluatedPercentageLabel.text = [NSString stringWithFormat:@"%.2f %%",((auditAwarded / (auditPointsPossible - auditNAPoints)) *100)];
    
    [self.graphView setElementNames:eleNames];
    [self.graphView setElementPercent:percents];
    
    
}
#pragma mark - TableView Delegates

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"ElementsRatingsCell";
    
    ElementRatingsCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[ElementRatingsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Elements *element = [self.elementsArray objectAtIndex:indexPath.row];
    
    cell.elementName.text = element.name;
    if (element.isRequired) {
        cell.required.text = @"R";
    }
    else cell.required.text = @"O";
    
    cell.pointsPossible.text = [NSString stringWithFormat:@"%.1f",element.pointsPossible-element.modefiedNAPoints];
    cell.pointsAwarded.text = [NSString stringWithFormat:@"%.1f",element.pointsAwarded];
    
    cell.percentage.text = [NSString stringWithFormat:@"%.2f %%", (element.pointsAwarded/(element.pointsPossible - element.modefiedNAPoints))*100];
    return cell;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.elementsArray count];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToAssumptions"]) {
        
        ScoringAssumptionsViewController * assVC = [segue destinationViewController];
        
        assVC.audit = self.audit;
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        [self.ElementRatingsTableView reloadData];
        [self.ElementRatingsTableView layoutIfNeeded];
        
        
        int pixelsToMove = self.ElementRatingsTableView.frame.size.height;
        
        CGRect rect         = self.ElementRatingsTableView.frame;
        rect.size.height    = self.ElementRatingsTableView.contentSize.height;
        
        if (rect.size.height < self.ElementRatingsTableView.frame.size.height) {
            //self.ElementRatingsTableView.frame =
        }
        else self.ElementRatingsTableView.frame  = rect;
        
        pixelsToMove = self.ElementRatingsTableView.frame.size.height - pixelsToMove;
        
        if (pixelsToMove<0)
            pixelsToMove = 0;
        
            
        //make the hieght view bigger
        rect = self.ratingsPDFView.frame;
        rect.size.height += pixelsToMove;
        int numPages = ceil( rect.size.height / 792 );
        rect.size.height = numPages * 792;
        self.ratingsPDFView.frame = rect;
        
        //move each uiElement under elements tableview
        rect = self.possibleLabel.frame;
        rect.origin.y += pixelsToMove;
        self.possibleLabel.frame = rect;
        
        rect = self.evaluatedLabel.frame;
        rect.origin.y += pixelsToMove;
        self.evaluatedLabel.frame = rect;
        
        rect = self.totalPossibleLabel.frame;
        rect.origin.y += pixelsToMove;
        self.totalPossibleLabel.frame = rect;
        
        rect = self.totalAwardedLabel.frame;
        rect.origin.y += pixelsToMove;
        self.totalAwardedLabel.frame = rect;
        
        rect = self.totalPercentageLabel.frame;
        rect.origin.y += pixelsToMove;
        self.totalPercentageLabel.frame = rect;
        
        rect = self.evaluatedAwardedLabel.frame;
        rect.origin.y += pixelsToMove;
        self.evaluatedAwardedLabel.frame = rect;
        
        rect = self.evaluatedPercentageLabel.frame;
        rect.origin.y += pixelsToMove;
        self.evaluatedPercentageLabel.frame = rect;
        
        rect = self.evaluatedPossibleLabel.frame;
        rect.origin.y += pixelsToMove;
        self.evaluatedPossibleLabel.frame = rect;
      
        rect = self.graphView.frame;
        rect.origin.y += pixelsToMove;
        self.graphView.frame = rect;
        
        
        //set the frame of this view to the bottom of the finalPdfview
//        rect = self.ratingsPDFView.frame;
//        rect.origin.y = reportVC.finalPFDView.frame.size.height;
//        self.ratingsPDFView.frame = rect;
//        
//        [reportVC.finalPFDView addSubview:self.ratingsPDFView];
//        [reportVC.finalPFDView sizeToFit];
//
    //    [reportVC.viewArray addObject:self.ratingsPDFView];
        
        [reportVC.viewArray setObject:self.ratingsPDFView atIndexedSubscript:7];

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
