//
//  ReportPagesViewController.m
//  DNV
//
//  Created by USI on 1/23/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ReportPagesViewController.h"
#import "TitleViewController.h"
#import "ReportDetailsViewController.h"
#import "ExecutiveSummaryViewController.h"

@interface ReportPagesViewController ()

@end

@implementation ReportPagesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.


    TitleViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TitleViewController"];
  //  ReportDetailsViewController *rdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TitleViewController"];
    
    [self setViewControllers:@[tvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        NSLog(@"Hooray I set my initial viewcontroller for my page view controller");
    }];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
//
//    
//        return nil;
//}
//
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
//
//    if ([viewController isKindOfClass:[TitleViewController class]]) {
//        ReportDetailsViewController *rdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportDetailsViewController"];
//        return  rdvc;
//        
//    }
//    
//    else return nil;
//
//    
//}


@end
