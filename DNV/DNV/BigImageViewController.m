//
//  BigImageViewController.m
//  DNV
//
//  Created by USI on 2/11/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "BigImageViewController.h"

@interface BigImageViewController ()

@end

@implementation BigImageViewController

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
    
     if (self.indexPath.section == 0)//camera image was selected
     {
         NSString *imagePath = [self.question.imageLocationArray objectAtIndex:self.indexPath.row];
         UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
         
         self.bigImageView.image = image;
    }
     else{
         NSString *imagePath = [self.question.drawnNotes objectAtIndex:self.indexPath.row];
         UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
         
         self.bigImageView.image = image; 
     }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonsPushed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)deleteButtonPushed:(id)sender {
    
    if (self.indexPath.section == 0)//camera image was selected
    {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.question.imageLocationArray];
        [tempArr removeObjectAtIndex:self.indexPath.row];
        self.question.imageLocationArray = tempArr;
        
    }
    else
    {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.question.drawnNotes];
        [tempArr removeObjectAtIndex:self.indexPath.row];
        self.question.drawnNotes = tempArr;
        
    }
    
    [self backButtonsPushed:self];
    
    
}
@end
