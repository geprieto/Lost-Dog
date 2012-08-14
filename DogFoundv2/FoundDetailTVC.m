//
//  FoundDetailTVC.m
//  DogFoundv2
//
//  Created by Gabriel Prieto Overeem on 4/23/12.
//  Copyright (c) 2012 Gabriel Prieto Overeem. All rights reserved.
//

#import "FoundDetailTVC.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation FoundDetailTVC
@synthesize delegate;
@synthesize foundNameTextField;
@synthesize foundBreedTextField;
@synthesize foundInfoTextView;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize found = _found;
@synthesize originalFoundImageFileName;
@synthesize foundImageFileName;
@synthesize imageView = _imageView;
@synthesize actView;
@synthesize msgAlert;

- (void)viewDidLoad
{
    NSLog(@"Setting the value of fields in this static table to that of the passed Found");
    
    self.foundNameTextField.text = self.found.name;
    self.foundBreedTextField.text = self.found.breed;
    self.foundInfoTextView.text = self.found.info;
    self.originalFoundImageFileName = self.found.image;
    self.foundImageFileName = self.originalFoundImageFileName;
    
    NSLog(@"Setting specialized keyboard functions");
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    NSLog(@"Setting image from Core Data: %@", originalFoundImageFileName);
    
    UIImage *image = [UIImage imageWithContentsOfFile:originalFoundImageFileName];
    self.imageView.image = image;
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    NSLog(@"Unloading view");
    
    [self setFoundNameTextField:nil];
    [self setFoundBreedTextField:nil];
    [self setFoundInfoTextView:nil];
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
        if ([fileMgr removeItemAtPath:self.found.image error:&error] != YES)
            NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        else
            NSLog(@"Deleting file %@", self.found.image);
        
        
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
        NSString *prefixString = @"Documents/";
        NSString *uniqueFileName = [NSString stringWithFormat:@"%@%@.png", prefixString, (__bridge NSString *)uuidString];
        CFRelease(uuidString);
        self.foundImageFileName = [NSHomeDirectory() stringByAppendingPathComponent:uniqueFileName];
        if ([UIImagePNGRepresentation(imageToSave) writeToFile:self.foundImageFileName atomically:YES] != YES)
            NSLog(@"Unable to save file");
        else
            NSLog(@"Saving file %@", self.foundImageFileName);
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
    NSLog(@"Telling the FoundDetailTVC Delegate that Save was tapped on the FoundDetailTVC");
    
    [self.found setName:foundNameTextField.text];
    [self.found setBreed:foundBreedTextField.text];
    [self.found setInfo:foundInfoTextView.text];
    [self.found setImage:self.foundImageFileName];
    
    NSLog(@"saving to database: image --> : %@", self.foundImageFileName);
    
    [self.managedObjectContext save:nil];  // write to database
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    Facebook *facebook = appDelegate.facebook;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString *graphPath = @"me/photos";
    
    NSData* imageData = UIImageJPEGRepresentation(self.imageView.image, 90);
    [params setObject:imageData forKey:@"source"];
    
    NSString *intro = NSLocalizedString(@"INTROFOUND", nil);
    NSString *middle = NSLocalizedString(@"MIDDLEFOUND", nil);
    NSString *end = NSLocalizedString(@"ENDFOUND", nil);
    NSString *message = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@", intro, foundNameTextField.text, middle, foundBreedTextField.text, end, foundInfoTextView.text];
    
    
    [params setObject:message forKey:@"message"];
    
    
    [facebook requestWithGraphPath:graphPath andParams:params andHttpMethod:@"POST" andDelegate:appDelegate];
    
    
    
    
    [self.delegate theSaveButtonOnTheFoundDetailTVCWasTapped:self];
}


@end