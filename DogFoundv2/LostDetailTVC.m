//
//  LostDetailTVC.m
//  DogLostv2
//
//  Created by Gabriel Prieto Overeem on 4/23/12.
//  Copyright (c) 2012 Gabriel Prieto Overeem. All rights reserved.
//

#import "LostDetailTVC.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation LostDetailTVC
@synthesize delegate;
@synthesize lostNameTextField;
@synthesize lostBreedTextField;
@synthesize lostInfoTextView;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize lost = _lost;
@synthesize originalLostImageFileName;
@synthesize lostImageFileName;
@synthesize imageView = _imageView;
@synthesize actView;
@synthesize msgAlert;

- (void)viewDidLoad
{
    NSLog(@"Setting the value of fields in this static table to that of the passed Lost");
    
    self.lostNameTextField.text = self.lost.name;
    self.lostBreedTextField.text = self.lost.breed;
    self.lostInfoTextView.text = self.lost.info;
    self.originalLostImageFileName = self.lost.image;
    self.lostImageFileName = self.originalLostImageFileName;
    
    NSLog(@"Setting specialized keyboard functions");
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    NSLog(@"Setting image from Core Data: %@", originalLostImageFileName);
    
    UIImage *image = [UIImage imageWithContentsOfFile:originalLostImageFileName];
    self.imageView.image = image;
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    NSLog(@"Unloading view");
    
    [self setLostNameTextField:nil];
    [self setLostBreedTextField:nil];
    [self setLostInfoTextView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) acontroller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) adelegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (adelegate == nil)
        || (acontroller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES;
    
    cameraUI.delegate = adelegate;
    
    [acontroller presentModalViewController: cameraUI animated: YES];
    return YES;
}

- (IBAction) showCameraUI
{
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self dismissModalViewControllerAnimated: YES];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        self.imageView.image = imageToSave;
        // For error information
        NSError *error;
        // Create file manager
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if ([fileMgr removeItemAtPath:self.lost.image error:&error] != YES)
            NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        else
            NSLog(@"Deleting file %@", self.lost.image);
        
        
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
        NSString *prefixString = @"Documents/";
        NSString *uniqueFileName = [NSString stringWithFormat:@"%@%@.png", prefixString, (__bridge NSString *)uuidString];
        CFRelease(uuidString);
        self.lostImageFileName = [NSHomeDirectory() stringByAppendingPathComponent:uniqueFileName];
        if ([UIImagePNGRepresentation(imageToSave) writeToFile:self.lostImageFileName atomically:YES] != YES)
            NSLog(@"Unable to save file");
        else
            NSLog(@"Saving file %@", self.lostImageFileName);
    }
    
    [self dismissModalViewControllerAnimated: YES];
}


-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


- (IBAction)save:(id)sender
{
    NSLog(@"Telling the LostDetailTVC Delegate that Save was tapped on the LostDetailTVC");
    
    [self.lost setName:lostNameTextField.text];
    [self.lost setBreed:lostBreedTextField.text];
    [self.lost setInfo:lostInfoTextView.text];
    [self.lost setImage:self.lostImageFileName];
    
    NSLog(@"saving to database: image --> : %@", self.lostImageFileName);
    
    [self.managedObjectContext save:nil];  // write to database
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    Facebook *facebook = appDelegate.facebook;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString *graphPath = @"me/photos";
    
    NSData* imageData = UIImageJPEGRepresentation(self.imageView.image, 90);
    [params setObject:imageData forKey:@"source"];
    
    NSString *intro = NSLocalizedString(@"INTROLOST", nil);
    NSString *middle = NSLocalizedString(@"MIDDLELOST", nil);
    NSString *end = NSLocalizedString(@"ENDLOST", nil);
    NSString *message = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@", intro, lostNameTextField.text, middle, lostBreedTextField.text, end, lostInfoTextView.text];
    
    
    [params setObject:message forKey:@"message"];
    
    
    [facebook requestWithGraphPath:graphPath andParams:params andHttpMethod:@"POST" andDelegate:appDelegate];
    
    
    
    
    [self.delegate theSaveButtonOnTheLostDetailTVCWasTapped:self];
}


@end