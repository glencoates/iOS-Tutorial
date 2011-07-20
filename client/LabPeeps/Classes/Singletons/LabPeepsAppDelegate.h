//
//  LabPeepsAppDelegate.h
//  LabPeeps
//
//  Created by Glen Coates on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface LabPeepsAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
    UINavigationController *navigationController;

@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (LabPeepsAppDelegate *) get;

- (NSURL *)applicationDocumentsDirectory;

- (id) fetchEntityOfType:(NSString *)type withPredicate:(NSPredicate *)pred;
- (NSArray *) fetchEntitiesOfType:(NSString *)type withPredicate:(NSPredicate *)pred;
- (void) saveContext;

- (void) sync;

@end

