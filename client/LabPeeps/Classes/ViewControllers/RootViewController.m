//
//  RootViewController.m
//  LabPeeps
//
//  Created by Glen Coates on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "Peep.h"
#import "Skill.h"

#import "SkillListViewController.h"

@implementation RootViewController

#pragma mark -
#pragma mark View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Peeps";

    // We don't really want the top left and top right buttons right now
//    // Set up the edit and add buttons.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
//    self.navigationItem.rightBarButtonItem = addButton;
//    [addButton release];
}


// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


/**
 *  We want subtitles for our peeps.
 */
- (UITableViewCellStyle) cellStyle
{
    return UITableViewCellStyleSubtitle;
}


/**
 *  Show the name and the number of skills each Peep has.
 */
- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Peep *peep = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.textLabel.text = peep.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d skills", [peep.skills count]];
}


/**
 *  We show Peeps in the root VC.
 */
- (NSString *) fetchEntityName
{
    return @"Peep";
}


/**
 *  We sort by their names.
 */
- (NSArray *) fetchSortDescriptors
{
    return [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
}


//#pragma mark -
//#pragma mark Add a new object
//
//- (void)insertNewObject {
//
//    // Create a new instance of the entity managed by the fetched results controller.
//    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
//    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
//
//    // If appropriate, configure the new managed object.
//    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
//
//    // Save the context.
//    NSError *error = nil;
//    if (![context save:&error]) {
//        /*
//         Replace this implementation with code to handle the error appropriately.
//
//         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//         */
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//}
//
//
//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//
//    // Prevent new objects being added when in editing mode.
//    [super setEditing:(BOOL)editing animated:(BOOL)animated];
//    self.navigationItem.rightBarButtonItem.enabled = !editing;
//}


#pragma mark -
#pragma mark Table view data source

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];

        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.

             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate


/**
 *  Show the skill list for the Peep we tapped.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Peep *peep = [self.fetchedResultsController objectAtIndexPath:indexPath];
    SkillListViewController *skillListVC = [[SkillListViewController alloc] initWithPeep:peep];

    [self.navigationController pushViewController:skillListVC animated:YES];
    [skillListVC release];
}


@end

