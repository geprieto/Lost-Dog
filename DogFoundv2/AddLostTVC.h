//
//  AddLostTVC.h
//  DogFoundv2
//
//  Created by Gabriel Prieto Overeem on 4/23/12.
//  Copyright (c) 2012 Carnegie Institution for Science. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lost.h"
 
@class AddLostTVC;
@protocol AddLostTVCDelegate
- (void)theSaveButtonOnTheAddLostTVCWasTapped:(AddLostTVC *)controller;
@end

@interface AddLostTVC : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImageView *_imageView;
    NSString *_lostImageFileName;
}
@property (nonatomic, weak) id <AddLostTVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *lostNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lostBreedTextField;
@property (weak, nonatomic) IBOutlet UITextView *lostInfoTextView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) NSString *lostImageFileName;

- (IBAction)save:(id)sender;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction) showCameraUI;

@end