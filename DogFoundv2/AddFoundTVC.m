//
//  AddFoundTVC.m
//  DogFoundv2
//
//  Created by Gabriel Prieto Overeem on 4/23/12.
//  Copyright (c) 2012 Carnegie Institution for Science. All rights reserved.
//

#import "AddFoundTVC.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation AddFoundTVC
@synthesize delegate;
@synthesize foundNameTextField;
@synthesize foundBreedTextField;
@synthesize foundInfoTextView;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize imageView = _imageView;
@synthesize foundImageFileName = _foundImageFileName;

- (void)viewDidLoad
{
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setFoundNameTextField:nil];
    [self setFoundBreedTextField:nil];
    [self setFoundInfoTextView:nil];
    [self setFoundImageFileName:nil];
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

        
        // Save the new image (original or edited) to the Camera Roll
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
        NSString *prefixString = @"Documents/";
        NSString *uniqueFileName = [NSString stringWithFormat:@"%@%@.png", prefixString, (__bridge NSString *)uuidString];
        CFRelease(uuidString);
        self.foundImageFileName = [NSHomeDirectory() stringByAppendingPathComponent:uniqueFileName];
        [UIImagePNGRepresentation(imageToSave) writeToFile:self.foundImageFileName atomically:YES];
    }
    
    [self dismissModalViewControllerAnimated: YES];
}

- (IBAction)save:(id)sender
{
    NSLog(@"Telling the AddFoundTVC Delegate that Save was tapped on the AddFoundTVC");
    
    Found *found = [NSEntityDescription insertNewObjectForEntityForName:@"Found"
                                               inManagedObjectContext:self.managedObjectContext];
    
    found.name = foundNameTextField.text;
    found.breed = foundBreedTextField.text;
    found.info = foundInfoTextView.text;
    found.image = self.foundImageFileName;
    
    [self.managedObjectContext save:nil];  // write to database
    
    [self.delegate theSaveButtonOnTheAddFoundTVCWasTapped:self];
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}

@end