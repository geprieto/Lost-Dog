//
//  LostDetailTVC.h
//  DogFoundv2
//
//  Created by Gabriel Prieto Overeem on 4/23/12.
//  Copyright (c) 2012 Carnegie Institution for Science. All rights reserved.
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
    NSString *_lostImageFileName;
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

- (IBAction)save:(id)sender;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction) showCameraUI;

@end