//
//  Lost.h
//  Lost Dog
//
//  Created by Gabriel Prieto on 6/16/12.
//  Copyright (c) 2012 geprieto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Lost : NSManagedObject

@property (nonatomic, retain) NSString * breed;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * image;

@end
