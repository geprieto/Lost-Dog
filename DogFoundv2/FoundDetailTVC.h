//
//  FoundDetailTVC.h
//  DogFoundv2
//
//  Created by Gabriel Prieto Overeem on 4/23/12.
//  Copyright (c) 2012 Carnegie Institution for Science. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Found.h"
#import "AppDelegate.h"

@class FoundDetailTVC;
@protocol FoundDetailTVCDelegate
- (void)theSaveButtonOnTheFoundDetailTVCWasTapped:(FoundDetailTVC *)controller;
@end

@interface FoundDetailTVC : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImageView *_imageView;
    NSString *_foundImageFileName;
}

@property (nonatomic, weak) id <FoundDetailTVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *foundNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *foundBreedTextField;
@property (weak, nonatomic) IBOutlet UITextView *foundInfoTextView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Found *found;
@property (nonatomic, retain) NSString *foundImageFileName;
@property (weak, nonatomic) NSString *originalFoundImageFileName;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

- (IBAction)save:(id)sender;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction) showCameraUI;

@end