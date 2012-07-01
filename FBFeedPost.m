//
//  FBFeedPost.m
//  Facebook Demo
//
//  Created by Andy Yanok on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBFeedPost.h"


@implementation FBFeedPost
@synthesize caption, image, delegate;

- (id) initWithPhoto:(UIImage*) _image name:(NSString*) _name {
	self = [super init];
    NSLog(@"inside initWithPhoto...");
	if (self) {
		image = _image;
		caption = _name;
	}
	return self;
}

- (void) publishPostWithDelegate:(id) _delegate {
	
	//store the delegate incase the user needs to login
	self.delegate = _delegate;
	
	// if the user is not currently logged in begin the session
	BOOL loggedIn = [[AppDelegate defaultManager] isLoggedIn];
	if (!loggedIn) {
		[[AppDelegate defaultManager] FBSessionBegin:self];
        NSLog(@"not logged in...");
	}
	else {
		NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
		
		//Need to provide POST parameters to the Facebook SDK for the specific post type
		NSString *graphPath = @"me/feed";
		
        [params setObject:@"status" forKey:@"type"];
        [params setObject:@"Test message..." forKey:@"message"];
        
        //graphPath = @"me/photos";
        //[params setObject:self.image forKey:@"source"];
        //[params setObject:self.caption forKey:@"message"];
		
		[[AppDelegate defaultManager] sendFBRequestWithGraphPath:graphPath params:params andDelegate:self];
	}	
}

#pragma mark -
#pragma mark FacebookSessionDelegate

- (void)fbDidLogin {
	[[AppDelegate defaultManager] setIsLoggedIn:YES];
	NSLog(@"fbDidLogin runing via post...");
	//after the user is logged in try to publish the post
	[self publishPostWithDelegate:self.delegate];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
	[[AppDelegate defaultManager] setIsLoggedIn:NO];
	
}

@end
