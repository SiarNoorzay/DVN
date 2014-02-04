//
//  ImportMergeViewController.h
//  DNV
//
//  Created by USI on 1/14/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImportMergeViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSArray * jsonFiles;
@property (strong, nonatomic) NSArray * localFiles;
@property (strong, nonatomic) NSString * currentFile;
@property (strong, nonatomic) NSString * currentFileType;

@property (strong, nonatomic) NSArray * sectionHeaders;

@property (strong, nonatomic) IBOutlet UICollectionView *jsonFileCollection;

@end
