//
//  AppDelegate.m
//  DogFoundv2
//
//  Created by Gabriel Prieto Overeem on 4/23/12.
//  Copyright (c) 2012 Carnegie Institution for Science. All rights reserved.
//

#import "AppDelegate.h"
#import "LostTVC.h"
#import "FoundTVC.h"
#import "FBConnect.h"

static AppDelegate *defaultWrapper = nil;

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize isLoggedIn;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // The Tab Bar
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    // The Two Navigation Controllers attached to the Tab Bar (At Tab Bar Indexes 0 and 1)
    UINavigationController *lostTVCnav = [[tabBarController viewControllers] objectAtIndex:0];
    UINavigationController *foundTVCnav = [[tabBarController viewControllers] objectAtIndex:1];
    
    // The Lost Table View Controller (First Nav Controller Index 0)
    LostTVC *lostTVC = [[lostTVCnav viewControllers] objectAtIndex:0];
    lostTVC.managedObjectContext = self.managedObjectContext;    
    
    // The Found Table View Controller (Second Nav Controller Index 0)
    FoundTVC *foundTVC = [[foundTVCnav viewControllers] objectAtIndex:0];
    foundTVC.managedObjectContext = self.managedObjectContext;
    
    //NOTE: Be very careful to change these indexes if you change the tab order
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DogFoundv2.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - FBConnect

+ (id) defaultManager {
	
	if (!defaultWrapper)
		defaultWrapper = [[AppDelegate alloc] init];
	
	return defaultWrapper;
}

- (void) setIsLoggedIn:(BOOL) _loggedIn {
	isLoggedIn = _loggedIn;
	
	if (isLoggedIn) {
		[[NSUserDefaults standardUserDefaults] setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
		[[NSUserDefaults standardUserDefaults] setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	else {
		[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"FBAccessTokenKey"];
		[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"FBExpirationDateKey"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void) FBSessionBegin:(id<FBSessionDelegate>) _delegate {
	
	if (facebook == nil) {
        facebook = [[Facebook alloc] initWithAppId:FB_APP_ID andDelegate:self];
         facebook.sessionDelegate = self;
        NSLog(@"fb initiated");
        NSLog(FB_API_KEY);
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"Uder defaults:");
        NSLog([defaults objectForKey:@"FBAccessTokenKey"]);
        if ([defaults objectForKey:@"FBAccessTokenKey"]
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
            facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
            isLoggedIn = YES;
            NSLog(@"logged in!");
        }
		
	}
	
	NSArray * permissions = [NSArray arrayWithObjects:
							 @"publish_stream",
							 nil];
	
	if (![facebook isSessionValid]) {
        NSLog(@"permissions are not valid, authorizing...");
        [facebook authorize:permissions];
    }
}


- (void) sendFBRequestWithGraphPath:(NSString*) _path params:(NSMutableDictionary*) _params andDelegate:(id) _delegate {
	
	if (_delegate == nil)
		_delegate = self;
	
	if (_params != nil && _path != nil) {
		
        NSLog(@"params and path not nil");
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		[facebook requestWithGraphPath:_path andParams:_params andHttpMethod:@"POST" andDelegate:_delegate];
	}
}

    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}
    
@end
