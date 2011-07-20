//
//  Peep.m
//  LabPeeps
//
//  Created by Glen Coates on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Peep.h"
#import "Skill.h"

@implementation Peep

@dynamic name;
@dynamic byline;
@dynamic skills;


/**
 *  Creates a new peep with the supplied name and skills (which should be just an array of strings).
 */
+ (Peep *) createInContext:(NSManagedObjectContext *)moc
                      name:(NSString *)name
                    skills:(NSArray *)skills
{
    // First create the new Peep and set its name
    Peep *peep = [NSEntityDescription insertNewObjectForEntityForName:@"Peep" inManagedObjectContext:moc];
    peep.name = name;

    // Loop through all the skill strings and create Skill entities for them, linking them to the peep as we go
    for (NSString *skillInfo in skills)
    {
        Skill *skill = [NSEntityDescription insertNewObjectForEntityForName:@"Skill" inManagedObjectContext:moc];
        skill.info = skillInfo;
        skill.peep = peep;
    }

    return peep;
}

@end
