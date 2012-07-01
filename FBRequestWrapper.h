//
//  FBRequestWrapper.h
//  Facebook Demo
//
//  Created by Andy Yanok on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

#define FB_APP_ID @"145544612236231"
#define FB_API_KEY @"145544612236231"
#define FB_APP_SECRET @"84789d91c29abb4f3c033b7ed6359fc2"

@interface FBRequestWrapper : NSObject <FBRequestDelegate, FBSessionDelegate> 
{
	Facebook *facebook;
	BOOL isLoggedIn;
}

@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, retain) Facebook *facebook;

+ (id) defaultManager;
- (void) setIsLoggedIn:(BOOL) _loggedIn;
- (void) FBSessionBegin:(id<FBSessionDelegate>) _delegate;
- (void) FBLogout;
- (void) sendFBRequestWithGraphPath:(NSString*) _path params:(NSMutableDictionary*) _params andDelegate:(id) _delegate;

@end
