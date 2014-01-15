//
//  NotesViewController.h
//  DNV
//
//  Created by USI on 1/13/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceRecognizer.h"


@interface NotesViewController : UIViewController<UITextViewDelegate>

@property (strong,nonatomic) NSString *text;

@property (strong, nonatomic) IBOutlet UITextView *notesTextView;
@property (strong, nonatomic) IBOutlet UIButton *startStopButton;
@property (strong, nonatomic) IBOutlet UITextView *heardWordsTextView;

@property (strong, atomic) VoiceRecognizer *vr;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


- (IBAction)startStopButtonPushed:(id)sender;
- (IBAction)submitButtonPushed:(id)sender;

@end
