//
//  AddFoundTVC.h
//  DogFoundv2
//
//  Created by Gabriel Prieto Overeem on 4/23/12.
//  Copyright (c) 2012 Gabriel Prieto Overeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Found.h"

@class AddFoundTVC;
@protocol AddFoundTVCDelegate
- (void)theSaveButtonOnTheAddFoundTVCWasTapped:(AddFoundTVC *)controller;
@end

@interface AddFoundTVC : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImageView *_imageView;
    NSString *_foundImageFileName;
}
@property (nonatomic, weak) id <AddFoundTVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *foundNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *foundBreedTextField;
@property (weak, nonatomic) IBOutlet UITextView *foundInfoTextView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) NSString *foundImageFileName;

- (IBAction)save:(id)sender;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction) showCameraUI;

@end