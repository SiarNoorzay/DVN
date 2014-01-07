//
//  ClientViewController.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverControllerDelegate>

//Client CollectionView property
@property (strong, nonatomic) IBOutlet UICollectionView *ClientCollectionView;

//Instance of the PopOver Controller
@property (strong,nonatomic) UIPopoverController * popOver;

@end
