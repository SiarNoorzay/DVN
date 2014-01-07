//
//  ClientViewController.m
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ClientViewController.h"
#import "MainWindowPopOver.h"

@interface ClientViewController ()

@end

@implementation ClientViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ClientCell";
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel * nameLabel = (UILabel *)[cell viewWithTag:1];
    
    nameLabel.text = @"USI";
    
    return cell;
    
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MainWindowPopOver * popContent = [[MainWindowPopOver alloc]init];
    
    
    self.popOver = [[UIPopoverController alloc] initWithContentViewController:popContent];
    
    self.popOver.delegate = self;
    
    self.auditType = popContent.auditChoice;
    popContent.popOverContent = self.popOver;
    
    UICollectionViewCell * cell = [self.ClientCollectionView cellForItemAtIndexPath:indexPath];
    
    
    [self.popOver presentPopoverFromRect:cell.frame inView:self.ClientCollectionView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    NSLog(@"%d", self.auditType);
}


@end
