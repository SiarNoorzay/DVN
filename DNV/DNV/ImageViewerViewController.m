//
//  ImageViewerViewController.m
//  DNV
//
//  Created by USI on 2/10/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ImageViewerViewController.h"
#import "imageCell.h"
#import "BigImageViewController.h"

@interface ImageViewerViewController ()

@end

@implementation ImageViewerViewController

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

    [self.collectionView registerClass:[imageCell class] forCellWithReuseIdentifier:@"imageCell"];

    self.collectionView.backgroundColor = [UIColor clearColor];
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    
    flow.sectionInset = UIEdgeInsetsMake(25, 25, 25, 25);
    
    
    [self.collectionView reloadData];

}
-(void)viewWillAppear:(BOOL)animated
{
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.question.imageLocationArray.count;
    }
    return self.question.drawnNotes.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{


    if (indexPath.section == 0)
    {
        // create collection view cell
        imageCell *cell = (imageCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        
        NSString * imagePath= [self.question.imageLocationArray objectAtIndex:indexPath.row] ;
        
        NSLog(@"%@",imagePath);
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:imagePath];
        //cell.imageView.image = image; //place the image on the CustemCell.imageView as we prepared.
        
        // set tag to the indexPath.row so we can access it later
        [cell setTag:indexPath.row]; //we don't need this to access the cell but I left this in for your personal want.
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
        imgView.frame = cell.frame;
        
       image = [self image:image scaledToSize:cell.frame.size];

        //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:imagePath]];
        cell.backgroundColor = [UIColor colorWithPatternImage:image];
        
        return cell;
        
    }
    else
    {

        // create collection view cell
        imageCell *cell = (imageCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        
        NSString * imagePath= [self.question.drawnNotes objectAtIndex:indexPath.row] ;
        
        NSLog(@"%@",imagePath);
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:imagePath];
        //cell.imageView.image = image; //place the image on the CustemCell.imageView as we prepared.
        
        // set tag to the indexPath.row so we can access it later
        [cell setTag:indexPath.row]; //we don't need this to access the cell but I left this in for your personal want.
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
        imgView.frame = cell.frame;
        
        image = [self image:image scaledToSize:cell.frame.size];
        
        //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:imagePath]];
        cell.backgroundColor = [UIColor colorWithPatternImage:image];
        
        return cell;
    }

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    [self performSegueWithIdentifier:@"showBigImage" sender:self];

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSArray *indexPath = self.collectionView.indexPathsForSelectedItems;
    
    if ([[segue identifier] isEqualToString:@"showBigImage"]) {
        
        // Get destination view
        BigImageViewController * destVC = [segue destinationViewController];
        
        // Pass the information to your destination view
        [destVC setQuestion:self.question];
        
        [destVC setIndexPath:[indexPath objectAtIndex:0]];
        
    }
    
    
}
- (IBAction)dashBoardButonPushed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}
@end
