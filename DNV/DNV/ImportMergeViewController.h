//
//  ImportMergeViewController.h
//  DNV
//
//  Created by USI on 1/14/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Audit.h"
#import "DNVDatabaseManagerClass.h"

@class DBRestClient;

@interface ImportMergeViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>
{
    DBRestClient * restClient;
}

@property (strong, nonatomic) NSArray * jsonFiles;
@property (strong, nonatomic) NSArray * localFiles;
@property (strong, nonatomic) NSString * currentFile;
@property (strong, nonatomic) NSString * currentFileType;
@property (strong, nonatomic) NSString * wipPath;

@property NSString * directoryPath;

@property (strong, nonatomic) NSArray * sectionHeaders;

@property (strong, nonatomic) IBOutlet UICollectionView *jsonFileCollection;
@property (strong, nonatomic) IBOutlet UICollectionView *localFilesCollection;

@property (strong,nonatomic) Audit *mergingAudit;

@property (strong,nonatomic) Audit *currentAudit;

@property (strong, nonatomic) DNVDatabaseManagerClass * dnvDBManager;


@end
