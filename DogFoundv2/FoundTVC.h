//
//  FoundTVC.h
//  DogFoundv2
//
//  Created by Gabriel Prieto Overeem on 4/23/12.
//  Copyright (c) 2012 Carnegie Institution for Science. All rights reserved.
//

#import "AddFoundTVC.h" // so this class can be a AddFoundTVCDelegate
#import "CoreDataTableViewController.h" // so we can fetch
#import "Found.h"
#import "FoundDetailTVC.h" // so this class can be an RoleDetailTVCDelegate

@interface FoundTVC : CoreDataTableViewController <AddFoundTVCDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Found *selectedFound;
@end

