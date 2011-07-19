//
//  Peep.h
//  LabPeeps
//
//  Created by Glen Coates on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Peep :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * byline;
@property (nonatomic, retain) NSSet* skills;

@end


@interface Peep (CoreDataGeneratedAccessors)
- (void)addSkillsObject:(NSManagedObject *)value;
- (void)removeSkillsObject:(NSManagedObject *)value;
- (void)addSkills:(NSSet *)value;
- (void)removeSkills:(NSSet *)value;

@end

