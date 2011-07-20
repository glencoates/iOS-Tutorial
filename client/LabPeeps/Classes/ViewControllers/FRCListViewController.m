//
//  FRCListViewController.m
//  LabPeeps
//
//  Created by Glen Coates on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FRCListViewController.h"


@implementation FRCListViewController

@synthesize fetchedResultsController = fetchedResultsController_;
@synthesize managedObjectContext = managedObjectContext_;


#pragma mark -
#pragma mark Initialization


/**
 *  Initializes this list view with a provided context.
 */
- (id) initWithMOC:(NSManagedObjectContext *)moc
{
    if (self = [super initWithStyle:[self tableViewStyle]])
    {
        self.managedObjectContext = moc;
    }

    return self;
}


#pragma mark -
#pragma mark Memory management

- (void) dealloc
{
    self.managedObjectContext = nil;

    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;

    [super dealloc];
}


- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void) viewDidUnload
{
    // Disconnect the FRC from this view and then destroy it.  It will be recreated on demand.
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;

    [super viewDidUnload];
}


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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


#pragma mark -
#pragma mark Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];

    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self usableCellForTableView:tableView];
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark Subclasses should / can override these methods

/**
 *  Subclasses can override to customize the table style.
 */
- (UITableViewStyle) tableViewStyle
{
    return UITableViewStylePlain;
}


/**
 *  Subclasses can override to customize the cell style.
 */
- (UITableViewCellStyle) cellStyle
{
    return UITableViewCellStyleDefault;
}


/**
 *  Subclasses can override if they want a different way of generating a cell.
 */
- (UITableViewCell *) usableCellForTableView:(UITableView *)tableView
{
    NSString *cellID = [NSString stringWithFormat:@"%@Cell", [self class]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    // Make the cell if there aren't any buffered ones
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:[self cellStyle]
                                       reuseIdentifier:cellID] autorelease];
    }

    return cell;
}


/**
 *  Subclasses must override to implement their cell rendering
 */
- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSAssert1( NO, @"You must implement [%@ configureCell:atIndexPath:]", [self class] );
}


/**
 *  Subclasses must override this to specify what entity to fetch from the DB.
 */
- (NSString *) fetchEntityName
{
    NSAssert1( NO, @"You must implement [%@ fetchEntityName]", [self class] );

    return nil;
}


/**
 *  Subclasses can override this to restrict the set of entities that are fetched.
 */
- (NSPredicate *) fetchPredicate
{
    return nil;
}


/**
 *  Subclasses must override this to sort their fetch results.
 */
- (NSArray *) fetchSortDescriptors
{
    NSAssert1( NO, @"You must implement [%@ fetchSortDescriptors]", [self class] );

    return nil;
}


#pragma mark -
#pragma mark Fetched results controller

/**
 *  Custom accessor for the FRC that generates it on demand if it hasn't been intialized or if it
 *  was deliberately destroyed in unload.
 */
- (NSFetchedResultsController *) fetchedResultsController
{
    if (fetchedResultsController_)
    {
        return fetchedResultsController_;
    }

    NSEntityDescription *entity = [NSEntityDescription entityForName:[self fetchEntityName]
                                              inManagedObjectContext:self.managedObjectContext];

    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    [fetchRequest setSortDescriptors:[self fetchSortDescriptors]];
    [fetchRequest setPredicate:[self fetchPredicate]];

    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    fetchedResultsController_ = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    fetchedResultsController_.delegate = self;

    // Do the fetch to bring in the initial set of results
    NSError *err = nil;
    [fetchedResultsController_ performFetch:&err];
    NSAssert2( err == nil, @"Couldn't perform initial fetch on %@: %@", self, [err localizedDescription] );

    return fetchedResultsController_;
}


#pragma mark -
#pragma mark Fetched results controller delegate


- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}


- (void) controller:(NSFetchedResultsController *)controller
   didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
            atIndex:(NSUInteger)sectionIndex
      forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void) controller:(NSFetchedResultsController *)controller
    didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;

    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.

 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */


@end

