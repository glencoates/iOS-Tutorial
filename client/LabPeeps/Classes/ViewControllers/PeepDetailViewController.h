//
//  PeepDetailViewController.h
//  LabPeeps
//
//  Created by Glen Coates on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  This is a basic tableview that displays the skills that a Peep has.
 */
@interface PeepDetailViewController : UITableViewController
<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *frc_;
}

@property (nonatomic, retain) NSFetchedResultsController *frc;

@end
