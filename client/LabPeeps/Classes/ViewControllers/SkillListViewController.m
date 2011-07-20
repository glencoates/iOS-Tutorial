//
//  SkillListViewController.m
//  LabPeeps
//
//  Created by Glen Coates on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SkillListViewController.h"

#import "Peep.h"
#import "Skill.h"

@implementation SkillListViewController

@synthesize peep = peep_;


/**
 *  Create a new list VC that shows the skills of the provided Peep.
 */
- (id) initWithPeep:(Peep *)peep
{
    if (self = [super initWithMOC:[peep managedObjectContext]])
    {
        self.peep = peep;
        self.title = peep.name;
    }

    return self;
}


- (void) dealloc
{
    self.peep = nil;

    [super dealloc];
}


/**
 *  We show Skills here.
 */
- (NSString *) fetchEntityName
{
    return @"Skill";
}


/**
 *  We are only interested in the ones attached to our Peep.
 */
- (NSPredicate *) fetchPredicate
{
    return [NSPredicate predicateWithFormat:@"peep = %@", self.peep];
}


/**
 *  We sort our skills alphabetically.
 */
- (NSArray *) fetchSortDescriptors
{
    return [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"info" ascending:YES]];
}


/**
 *  Just stick the skill info in the cell.
 */
- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Skill *skill = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = skill.info;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumFontSize = 10;
}


@end
