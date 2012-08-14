//
//  AppDelegate.h
//  DogFoundv2
//
//  Created by Gabriel Prieto Overeem on 4/23/12.
//  Copyright (c) 2012 Gabriel Prieto Overeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate, FBRequestDelegate>{
    Facebook *facebook;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) Facebook *facebook;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
