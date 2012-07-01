//
//  FBFeedPost.h
//  Facebook Demo
//
//  Created by Andy Yanok on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol FBFeedPostDelegate;

@interface FBFeedPost : NSObject <FBRequestDelegate, FBSessionDelegate>
{
	NSString *caption;
	UIImage *image;
	
	__unsafe_unretained id <FBFeedPostDelegate> delegate;
}

@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) UIImage *image;

@property (nonatomic, assign) id <FBFeedPostDelegate> delegate;

- (id) initWithPhoto:(UIImage*) _image name:(NSString*) _name;
- (void) publishPostWithDelegate:(id) _delegate;

@end


@protocol FBFeedPostDelegate <NSObject>
@required
- (void) failedToPublishPost:(FBFeedPost*) _post;
- (void) finishedPublishingPost:(FBFeedPost*) _post;
@end