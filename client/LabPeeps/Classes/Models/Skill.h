//
//  Skill.h
//  LabPeeps
//
//  Created by Glen Coates on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Peep;

@interface Skill :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) Peep * peep;

@end



