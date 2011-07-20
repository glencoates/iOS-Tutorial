//
//  FRCListViewController.h
//  LabPeeps
//
//  Created by Glen Coates on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface FRCListViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (id) initWithMOC:(NSManagedObjectContext *)moc;

- (UITableViewStyle) tableViewStyle;
- (UITableViewCellStyle) cellStyle;
- (UITableViewCell *) usableCellForTableView:(UITableView *)tableView;
- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (NSString *) fetchEntityName;
- (NSPredicate *) fetchPredicate;
- (NSArray *) fetchSortDescriptors;

@end
