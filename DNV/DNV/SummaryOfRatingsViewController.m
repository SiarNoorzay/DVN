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
#import "GraphViewCell.h"



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
        if (ele.isApplicable) {
            NSString *eleName = ele.name;
            NSString *percent = [NSString stringWithFormat:@"%.2f",((ele.pointsAwarded / (ele.pointsPossible - ele.modefiedNAPoints)) *100)];
            
            [eleNames addObject:eleName];
            [percents addObject:percent];
        }
        
        
    }
    self.totalPossibleLabel.text = [NSString stringWithFormat:@"%.1f",auditPointsPossible];
    self.totalAwardedLabel.text = [NSString stringWithFormat:@"%.1f",auditAwarded];
    self.totalPercentageLabel.text = [NSString stringWithFormat:@"%.2f %%",((auditAwarded / auditPointsPossible) *100)];
    
    
    self.evaluatedPossibleLabel.text = [NSString stringWithFormat: @"%.1f",(auditPointsPossible - auditNAPoints)];
    self.evaluatedAwardedLabel.text = [NSString stringWithFormat:@"%.1f",auditAwarded];
    
    self.evaluatedPercentageLabel.text = [NSString stringWithFormat:@"%.2f %%",((auditAwarded / (auditPointsPossible - auditNAPoints)) *100)];
    NSMutableArray *allGraphViews = [[NSMutableArray alloc]initWithCapacity:1];
    
    GraphView *eleGraphView = [[GraphView alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [eleGraphView setName:self.audit.name];
    [eleGraphView setElementNames:eleNames];
    [eleGraphView setElementPercent:percents];
    [eleGraphView setIsAudit:YES];
    [allGraphViews addObject:eleGraphView];
    
    for (Elements *ele in self.audit.Elements) {
        if (ele.isApplicable)
        {
            NSMutableArray *subEleNames = [[NSMutableArray alloc]initWithCapacity:ele.Subelements.count];
            NSMutableArray *subElePercents = [[NSMutableArray alloc]initWithCapacity:ele.Subelements.count];
            
            for (SubElements *subEle in ele.Subelements) {
                
                if (subEle.isApplicable) {
                    [subEleNames addObject:subEle.name];
                    [subElePercents addObject:[NSString stringWithFormat:@"%.2f",((subEle.pointsAwarded / (subEle.pointsPossible - subEle.modefiedNAPoints)) *100)]];
                }
                
            }
            //subEleGraphView.elementNames = subEleNames;
            //  subEleGraphView.elementPercent = subElePercents;
            //  subEleGraphView.name = ele.name;
            GraphView *subEleGraphView = [[GraphView alloc] initWithElementNames:subEleNames andPercents:subElePercents];
            [subEleGraphView setName:ele.name];
            [subEleGraphView setIsAudit:NO];
            
            
            [allGraphViews addObject: subEleGraphView];
            
            //  [self.graphView setElementNames:subEleNames];
            //   [self.graphView setElementPercent:subElePercents];
        }
        NSLog(@"Count of graph views: %d", allGraphViews.count);

        }
        
    
    self.graphViews = allGraphViews;

    
}
#pragma mark - TableView Delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.ElementRatingsTableView) { return 44;}
    
    return 268;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.ElementRatingsTableView) {
        
        static NSString * cellIdentifier = @"ElementsRatingsCell";
        
        ElementRatingsCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[ElementRatingsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        Elements *element = [self.elementsArray objectAtIndex:indexPath.row];
        
        cell.elementName.text = element.name;
        if (element.isApplicable) {
            cell.required.text = @"No";
        }
        else cell.required.text = @"Yes";
        
        cell.pointsPossible.text = [NSString stringWithFormat:@"%.1f",element.pointsPossible];//-element.modefiedNAPoints];
        cell.pointsAwarded.text = [NSString stringWithFormat:@"%.1f",element.pointsAwarded];
        
        cell.percentage.text = [NSString stringWithFormat:@"%.2f %%", (element.pointsAwarded/(element.pointsPossible - element.modefiedNAPoints))*100];
        return cell;
        
        
    }
    static NSString * cellIdentifier2 = @"graphViewCell";
    GraphView *grphView = [self.graphViews objectAtIndex:indexPath.row];
    
    GraphViewCell * cell;// = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    
    if(cell == nil){
        cell = [[GraphViewCell alloc] initWithGraph:grphView reuseIdentifier:cellIdentifier2];
        
    }
    //    if(cell == nil){
    //        cell = [[GraphViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2 graphView:grphView];
    //
    //    }
    //cell.graphViewImage = grphView;
    //cell.elementSubName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    cell.elementSubName.text = grphView.name;
    
    cell.elementSubName.backgroundColor = [UIColor redColor];
    cell.backgroundColor = [UIColor lightGrayColor];
    
    cell.graphViewImage.backgroundColor = [UIColor clearColor];

    
    [cell.graphViewImage setNeedsDisplay];
    
    [cell.graphViewImage drawRect:CGRectMake(0, 0, 612, 340)];
    //-35, -42, 612, 260
    
 
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.ElementRatingsTableView) {
        
        return [self.elementsArray count];
        
    }
    
    return self.graphViews.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToAssumptions"]) {
        
        ScoringAssumptionsViewController * assVC = [segue destinationViewController];
        
        assVC.audit = self.audit;
        
        ReportDocViewController *reportVC = [ReportDocViewController sharedReportDocViewController];
        [self.ElementRatingsTableView reloadData];
        [self.ElementRatingsTableView layoutIfNeeded];
        
        self.ElementRatingsTableView.separatorColor = [UIColor clearColor];
        
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
        
        //set height to content size of element list and update pdfview size accordingly
        
        int pixelsToMove2 = self.graphsTableView.frame.size.height;
        rect = self.graphsTableView.frame;
        rect.size.height    = self.graphsTableView.contentSize.height;
        self.graphsTableView.frame  = rect;
        
        pixelsToMove2 = self.graphsTableView.frame.size.height - pixelsToMove2;
        
        if (pixelsToMove2<0)
            pixelsToMove2 = 0;
        
        //make the pdfview height bigger
        rect = self.ratingsPDFView.frame;
        rect.size.height += pixelsToMove2;
        
        numPages = ceil( rect.size.height / 792 );
        rect.size.height = numPages * 792;
        self.ratingsPDFView.frame = rect;
        
        
        
        
        //TODO: fix this sheit
        //     rect = self.graphView.frame;
        //     rect.origin.y += pixelsToMove;
        //     self.graphView.frame = rect;
        
        
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

