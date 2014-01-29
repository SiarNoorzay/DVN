//
//  NotesViewController.m
//  DNV
//
//  Created by USI on 1/13/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "NotesViewController.h"

@interface NotesViewController ()


@end

@implementation NotesViewController

bool start = true;

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
    self.notesTextView.text = self.text;
    [self.spinner stopAnimating];
    if (self.vr == nil) {
		self.vr = [[VoiceRecognizer alloc] init];
        [self.vr setup];
	}
    [self.vr addObserver:self forKeyPath:@"heardWord" options:0 context:nil];
    [self.vr addObserver:self forKeyPath:@"listening" options:0 context:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopButtonPushed:(id)sender {
    
    if (start) {
        [self.spinner startAnimating];
        
        [self.vr startVoiceRecognition];
        
        start = false;
        [self.startStopButton setTitle:@"Stop Voice Recognition" forState:UIControlStateNormal];
    }
    else
    {
        [self.vr stopVoiceRecognition];
        [self.startStopButton setTitle:@"Start Voice Recognition" forState:UIControlStateNormal];
        start = true;
    }
    
    
}

- (IBAction)submitButtonPushed:(id)sender {
    
    //TODO: add heard words to cursor position instead of at end
    
    /* Something like:
     NSString *contentsToAdd = @"some string";
     NSRange cursorPosition = [tf selectedRange];
     NSMutableString *tfContent = [[NSMutableString alloc] initWithString:[tf text]];
     [tfContent insertString:contentsToAdd atIndex:cursorPosition.location];
     [theTextField setText:tfContent];
     */
    
    NSString *temp = [[NSString alloc]initWithString:self.notesTextView.text];
    
    temp = [temp stringByAppendingString:[NSString stringWithFormat:@" %@",self.heardWordsTextView.text]];
    
    self.notesTextView.text = temp;
    self.text = temp;

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.vr && [keyPath isEqualToString:@"heardWord"]) {
        
        self.heardWordsTextView.text = self.vr.heardWord;
    }
    if (object == self.vr && [keyPath isEqualToString:@"listening"]) {
        
        if (self.vr.listening) {
            [self.spinner stopAnimating];
        }
    }

}
@end
