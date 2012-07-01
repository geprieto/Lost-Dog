//
//  FBRequestWrapper.m
//  Facebook Demo
//
//  Created by Andy Yanok on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBRequestWrapper.h"

static FBRequestWrapper *defaultWrapper = nil;

@implementation FBRequestWrapper
@synthesize isLoggedIn;

+ (id) defaultManager {
	
	if (!defaultWrapper)
		defaultWrapper = [[FBRequestWrapper alloc] init];
	
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
		facebook = [[Facebook alloc] initWithAppId:FB_APP_ID andDelegate:_delegate];
        facebook.sessionDelegate = _delegate;
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


- (void)fbDidLogin {
    isLoggedIn = YES;
    
    NSLog(@"fbDidLogin running... via wrapper");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}

- (void) fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
        
        isLoggedIn = NO;
    }
}

@end
