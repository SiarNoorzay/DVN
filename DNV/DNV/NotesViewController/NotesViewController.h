//
//  NotesViewController.h
//  DNV
//
//  Created by USI on 1/13/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;
@property (strong,nonatomic) NSString *text;


@end
