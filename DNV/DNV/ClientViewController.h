//
//  ClientViewController.h
//  DNV
//
//  Created by USI on 1/6/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNVDatabaseManagerClass.h"

@class DBRestClient;


@interface ClientViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverControllerDelegate>
{
    DBRestClient* restClient;
    
}

//Client CollectionView property
@property (strong, nonatomic) IBOutlet UICollectionView *ClientCollectionView;

//Instance of the PopOver Controller
@property (strong,nonatomic) UIPopoverController * clientPopOver;

@property (nonatomic) int auditType;

@property (nonatomic, readonly) DBRestClient *restClient;

@property (nonatomic) NSArray * clients;

@property (strong, nonatomic) DNVDatabaseManagerClass * dnvDBManager;

-(void)goToChoice;

//Activity Indicator
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;



@end
