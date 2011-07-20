//
//  SkillListViewController.h
//  LabPeeps
//
//  Created by Glen Coates on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FRCListViewController.h"

@class Peep;

@interface SkillListViewController : FRCListViewController
{
    // The peep we're showing the skills of
    Peep *peep_;
}

@property (nonatomic, retain) Peep *peep;

- (id) initWithPeep:(Peep *)peep;

@end
