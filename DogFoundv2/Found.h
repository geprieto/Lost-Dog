//
//  Found.h
//  Lost Dog
//
//  Created by Gabriel Prieto on 6/16/12.
//  Copyright (c) 2012 Gabriel Prieto Overeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Found : NSManagedObject

@property (nonatomic, retain) NSString * breed;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * image;

@end
