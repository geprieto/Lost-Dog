//
//  AppDelegate.h
//  DogFoundv2
//
//  Created by Gabriel Prieto Overeem on 4/23/12.
//  Copyright (c) 2012 Carnegie Institution for Science. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"


#define FB_APP_ID @"145544612236231"
#define FB_API_KEY @"145544612236231"
#define FB_APP_SECRET @"84789d91c29abb4f3c033b7ed6359fc2"

@interface AppDelegate : UIResponder <UIApplicationDelegate,FBRequestDelegate, FBSessionDelegate>{
    Facebook *facebook;
	BOOL isLoggedIn;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, retain) Facebook *facebook;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (id) defaultManager;
- (void) setIsLoggedIn:(BOOL) _loggedIn;
- (void) FBSessionBegin:(id<FBSessionDelegate>) _delegate;
- (void) FBLogout;
- (void) sendFBRequestWithGraphPath:(NSString*) _path params:(NSMutableDictionary*) _params andDelegate:(id) _delegate;


@end
