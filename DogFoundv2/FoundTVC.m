//
//  FoundTVC.m
//  DogFoundv2
//
//  Created by Gabriel Prieto Overeem on 4/23/12.
//  Copyright (c) 2012 Carnegie Institution for Science. All rights reserved.
//

#import "FoundTVC.h"

@implementation FoundTVC

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize selectedFound;

- (void)setupFetchedResultsController
{
    // 1 - Decide what Entity you want
    NSString *entityName = @"Found"; // Put your entity name here
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
    static NSString *CellIdentifier = @"Found Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Found *found = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = found.name;
    cell.detailTextLabel.text = found.breed;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Add Found Segue"])
	{
        NSLog(@"Setting FoundTVC as a delegate of AddFoundTVC");
        
        AddFoundTVC *addFoundTVC = segue.destinationViewController;
        addFoundTVC.delegate = self;
        addFoundTVC.managedObjectContext = self.managedObjectContext;
	}
    else if ([segue.identifier isEqualToString:@"Found Detail Segue"])
    {
        NSLog(@"Setting FoundTVC as a delegate of FoundDetailTVC");
        FoundDetailTVC *foundDetailTVC = segue.destinationViewController;
        foundDetailTVC.delegate = self;
        foundDetailTVC.managedObjectContext = self.managedObjectContext;
        
        // Store selected Found in selectedFound property
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.selectedFound = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSLog(@"Passing selected role (%@) to FoundDetailTVC", self.selectedFound.name);
        foundDetailTVC.found = self.selectedFound;
    }
    else if ([segue.identifier isEqualToString:@"Settings Segue"])
    {
        NSLog(@"Using Settings");
    }
    else {
        NSLog(@"Unidentified Segue Attempted!");
    }
}
- (void)theSaveButtonOnTheAddFoundTVCWasTapped:(AddFoundTVC *)controller
{
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
}

- (void)theSaveButtonOnTheFoundDetailTVCWasTapped:(FoundDetailTVC *)controller
{
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the found object that was swiped
        Found *foundToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting (%@)", foundToDelete.name);
        // For error information
        NSError *error;
        // Create file manager
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if ([fileMgr removeItemAtPath:foundToDelete.image error:&error] != YES)
            NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        [self.managedObjectContext deleteObject:foundToDelete];
        [self.managedObjectContext save:nil];
        
        // Delete the (now empty) row on the table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self performFetch];
        
        [self.tableView endUpdates];
    }
}

@end