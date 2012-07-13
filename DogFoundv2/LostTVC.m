//
//  LostTVC.m
//  DogFoundv2
//
//  Created by Gabriel Prieto Overeem on 4/23/12.
//  Copyright (c) 2012 Carnegie Institution for Science. All rights reserved.
//

#import "LostTVC.h"

@implementation LostTVC

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize selectedLost;

- (void)setupFetchedResultsController
{
    // 1 - Decide what Entity you want
    NSString *entityName = @"Lost"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    //request.predicate = [NSPredicate predicateWithFormat:@"Role.name = Blah"];
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self performFetch];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Lost Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Lost *lost = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = lost.name;
    cell.detailTextLabel.text = lost.breed;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Add Lost Segue"])
	{
        NSLog(@"Setting LostTVC as a delegate of AddLostTVC");
        
        AddLostTVC *addLostTVC = segue.destinationViewController;
        addLostTVC.delegate = self;
        addLostTVC.managedObjectContext = self.managedObjectContext;
	}
    else if ([segue.identifier isEqualToString:@"Lost Detail Segue"])
    {
        NSLog(@"Setting LostTVC as a delegate of LostDetailTVC");
        LostDetailTVC *lostDetailTVC = segue.destinationViewController;
        lostDetailTVC.delegate = self;
        lostDetailTVC.managedObjectContext = self.managedObjectContext;
        
        // Store selected Lost in selectedLost property
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.selectedLost = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSLog(@"Passing selected role (%@) to LostDetailTVC", self.selectedLost.name);
        lostDetailTVC.lost = self.selectedLost;
    }
    else if ([segue.identifier isEqualToString:@"Settings Segue"])
    {
        NSLog(@"Using Settings");
    }
    else {
        NSLog(@"Unidentified Segue Attempted!");
    }
}
- (void)theSaveButtonOnTheAddLostTVCWasTapped:(AddLostTVC *)controller
{
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
}

- (void)theSaveButtonOnTheLostDetailTVCWasTapped:(LostDetailTVC *)controller
{
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the lost object that was swiped
        Lost *lostToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting (%@)", lostToDelete.name);
        // For error information
        NSError *error;
        // Create file manager
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if ([fileMgr removeItemAtPath:lostToDelete.image error:&error] != YES)
            NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        [self.managedObjectContext deleteObject:lostToDelete];
        [self.managedObjectContext save:nil];
        
        // Delete the (now empty) row on the table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self performFetch];
        
        [self.tableView endUpdates];
    }
}

@end