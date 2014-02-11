//
//  ImagePopOverViewController.m
//  DNV
//
//  Created by USI on 2/10/14.
//  Copyright (c) 2014 USI. All rights reserved.
//

#import "ImagePopOverViewController.h"
#import "ImageViewerViewController.h"

@interface ImagePopOverViewController ()

@end

@implementation ImagePopOverViewController

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

- (IBAction)takePicturePushed:(id)sender {
    
    [self takePicture:true];
    
}

- (IBAction)choosePicPushed:(id)sender {
    
    [self takePicture:false];
    
}

#pragma mark - Image picker delegate methdos

- (void)takePicture:(BOOL)useCamera {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
#if TARGET_IPHONE_SIMULATOR
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    if (useCamera) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
#endif
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    //    [self presentModalViewController:imagePickerController animated:YES];
    [self presentViewController:imagePickerController animated:YES completion:Nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Resize the image from the camera if we need to
    //	UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) interpolationQuality:kCGInterpolationHigh];
    
    // Crop the image to a square if we wanted.
    // UIImage *croppedImage = [scaledImage croppedImage:CGRectMake((scaledImage.size.width -photo.frame.size.width)/2, (scaledImage.size.height -photo.frame.size.height)/2, photo.frame.size.width, photo.frame.size.height)];
    // Show the photo on the screen
    
    
    // self.view.backgroundColor = [UIColor colorWithPatternImage: image];
    
    //save image to file at self.cameraImage
    if (image != nil) {
        // Create path.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        // Save image.
        
        if (self.question.imageLocationArray == nil) {
            ///alloc string array and save image with number = 0
            NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:1];
            
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat: @"%d-cameraImage-%d.png",self.question.questionID,0]];
            
            [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
            
            [arr addObject:filePath];
            self.question.imageLocationArray = arr;
            
        }
        else {
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat: @"%d-cameraImage-%d.png",self.question.questionID,self.question.imageLocationArray.count]];
            
            [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
            NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:self.question.imageLocationArray];
            
            [arr addObject:filePath];
            self.question.imageLocationArray = arr;
        }
        for (NSString *str in self.question.imageLocationArray) {
            NSLog(@"Images in this question: %@", str);
        }
        
    }
    
    
    //    [picker dismissModalViewControllerAnimated:NO];
    [picker dismissViewControllerAnimated:NO completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //    [picker dismissModalViewControllerAnimated:NO];
    [picker dismissViewControllerAnimated:NO completion:nil];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAllImages"]) {
        
        // Get destination tabbar
        ImageViewerViewController * destVC = [segue destinationViewController];
        
        // Pass the information to your destination view
        destVC.question = self.question;
        
    }
}


@end
