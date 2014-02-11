//
//  ImageViewerViewController.h
//  DNV
//
//  Created by USI on 2/10/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Questions.h"


@interface ImageViewerViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) Questions *question;

- (IBAction)dashBoardButonPushed:(id)sender;

@end
