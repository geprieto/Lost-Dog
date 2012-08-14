//
//  LostDetailTVC.h
//  DogFoundv2
//
//  Created by Gabriel Prieto Overeem on 4/23/12.
//  Copyright (c) 2012 Gabriel Prieto Overeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lost.h"
#import "AppDelegate.h"

@class LostDetailTVC;
@protocol LostDetailTVCDelegate
- (void)theSaveButtonOnTheLostDetailTVCWasTapped:(LostDetailTVC *)controller;
@end

@interface LostDetailTVC : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImageView *_imageView;
}

@property (nonatomic, weak) id <LostDetailTVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *lostNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lostBreedTextField;
@property (weak, nonatomic) IBOutlet UITextView *lostInfoTextView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Lost *lost;
@property (nonatomic, retain) NSString *lostImageFileName;
@property (weak, nonatomic) NSString *originalLostImageFileName;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) UIActivityIndicatorView *actView;
@property (retain, nonatomic) UIAlertView *msgAlert;

- (IBAction)save:(id)sender;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction) showCameraUI;

@end