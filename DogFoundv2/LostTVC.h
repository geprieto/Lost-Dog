//
//  LostTVC.h
//  DogFoundv2
//
//  Created by Gabriel Prieto Overeem on 4/23/12.
//  Copyright (c) 2012 Gabriel Prieto Overeem. All rights reserved.
//

#import "AddLostTVC.h" // so this class can be a AddLostTVCDelegate
#import "CoreDataTableViewController.h" // so we can fetch
#import "Lost.h"
#import "LostDetailTVC.h" // so this class can be an LostDetailTVCDelegate

@interface LostTVC : CoreDataTableViewController <AddLostTVCDelegate, LostDetailTVCDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Lost *selectedLost;
@end
 
