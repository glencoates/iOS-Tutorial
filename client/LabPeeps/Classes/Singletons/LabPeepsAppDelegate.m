//
//  LabPeepsAppDelegate.m
//  LabPeeps
//
//  Created by Glen Coates on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LabPeepsAppDelegate.h"
#import "RootViewController.h"

#import "Peep.h"
#import "Skill.h"

#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"

@implementation LabPeepsAppDelegate

@synthesize window;
@synthesize navigationController;


static LabPeepsAppDelegate *s_instance_ = nil;


/**
 *  Static accessor to pull a reference to the singleton.
 */
+ (LabPeepsAppDelegate *) get
{
    return s_instance_;
}


/**
 *  Grabs the updated object database from the server.
 */
- (void) sync
{
    // Fetch the stuff from the server
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.103:8000/peeps"];
    ASIHTTPRequest *req = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
    [req setTimeOutSeconds:5.0];
    [req startSynchronous];

    NSData *responseData = [req responseData];

    if (responseData == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wah!"
                                                        message:@"Couldn't connect to server"
                                                       delegate:self
                                              cancelButtonTitle:@"I'll survive"
                                              otherButtonTitles:nil];

        [alert show];
        [alert release];
    }

    // Unpack the response JSON into a native dictionary
    NSError *err = nil;
    NSArray *response = [[CJSONDeserializer deserializer] deserializeAsArray:responseData error:&err];
    NSAssert1( err == nil, @"Couldn't deserialize response: %@", [err localizedDescription] );

    // Form a set of all the object IDs that exist now
    NSMutableSet *originalIDs = [NSMutableSet set];
    [originalIDs addObjectsFromArray:[[self fetchEntitiesOfType:@"Peep" withPredicate:nil] valueForKey:@"objectID"]];
    [originalIDs addObjectsFromArray:[[self fetchEntitiesOfType:@"Skill" withPredicate:nil] valueForKey:@"objectID"]];

    // Form a set of all the ones the server sends
    NSMutableSet *touchedEntities = [NSMutableSet set];

    // Iterate through the response and create / update entities
    for (NSDictionary *peepDict in response)
    {
        // Look up the existing peep, or create it if it doesn't exist
        NSString *name = [peepDict valueForKey:@"name"];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"name = %@", name];
        Peep *peep = [self fetchEntityOfType:@"Peep" withPredicate:pred];

        if (peep == nil)
        {
            peep = [NSEntityDescription insertNewObjectForEntityForName:@"Peep"
                                                 inManagedObjectContext:self.managedObjectContext];
            peep.name = name;
        }

        [touchedEntities addObject:peep];

        // Iterate through skills and create / update as necessary
        for (NSString *skillInfo in [peepDict valueForKey:@"skills"])
        {
            pred = [NSPredicate predicateWithFormat:@"peep = %@ && info = %@", peep, skillInfo];
            Skill *skill = [self fetchEntityOfType:@"Skill" withPredicate:pred];

            if (skill == nil)
            {
                skill = [NSEntityDescription insertNewObjectForEntityForName:@"Skill"
                                                      inManagedObjectContext:self.managedObjectContext];
                skill.info = skillInfo;
                skill.peep = peep;
            }

            [touchedEntities addObject:skill];
        }
    }

    // This causes all the new object IDs to be permanent
    [self saveContext];

    // Now we can calculate the diff set between the new and old
    NSMutableSet *touchedIDs = [touchedEntities valueForKey:@"objectID"];
    [originalIDs minusSet:touchedIDs];

    for (NSManagedObjectID *orphanID in originalIDs)
    {
        NSManagedObject *orphan = [self.managedObjectContext objectWithID:orphanID];
        [self.managedObjectContext deleteObject:orphan];
    }
}


#pragma mark -
#pragma mark Application lifecycle

- (void)awakeFromNib {

    RootViewController *rootViewController = (RootViewController *)[navigationController topViewController];
    [rootViewController initWithMOC:self.managedObjectContext];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Install static pointer
    s_instance_ = self;

    // Check to see if there are already any peeps in the database
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Peep" inManagedObjectContext:moc];
    NSFetchRequest *fetch = [[[NSFetchRequest alloc] init] autorelease];
    [fetch setEntity:entity];

    NSError *err = nil;
    NSArray *results = [moc executeFetchRequest:fetch error:&err];
    NSAssert1( err == nil, @"Couldn't fetch entities during bootstrap: %@", [err localizedDescription] );

    // If there aren't any, let's seed the DB with some sample data
    if ([results count] == 0)
    {
        [Peep createInContext:moc
                         name:@"Bella Acton"
                       skills:[NSArray arrayWithObjects:
                               @"Being awesome", @"Making cups of tea", @"Deserting the labs", nil]];

        [Peep createInContext:moc
                         name:@"Dick Talens"
                       skills:[NSArray arrayWithObjects:
                               @"Picking Django over Rails", @"Benchpressing the rest of his team", nil]];

        [Peep createInContext:moc
                         name:@"Dave Cascino"
                       skills:[NSArray arrayWithObjects:
                               @"Getting in the zone", @"Having a bigger screen than me", nil]];

        [self saveContext];

        NSLog( @"Successfully seeded the database with some sample data" );
    }

    // Set the navigation controller as the window's root view controller and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    [self sync];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [self saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}


/**
 *  Fetches a single entity of a given type matching the predicate.  Error if more than one result.
 */
- (id) fetchEntityOfType:(NSString *)type withPredicate:(NSPredicate *)pred
{
    NSArray *results = [self fetchEntitiesOfType:type withPredicate:pred];
    NSAssert2( [results count] <= 1, @"Too many results (%d) for %@ fetch", [results count], type );

    return [results count] ? [results lastObject] : nil;
}


/**
 *  Fetches all entities of a type matching the request.
 */
- (NSArray *) fetchEntitiesOfType:(NSString *)type withPredicate:(NSPredicate *)pred
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:type
                                              inManagedObjectContext:self.managedObjectContext];

    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    [fetch setPredicate:pred];

    NSError *err = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:&err];
    NSAssert2( err == nil, @"Couldn't fetch entities of type %@: %@", type, [err localizedDescription] );

    return results;
}


- (void)saveContext {

    NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.

             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {

    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {

    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"LabPeeps" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {

    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LabPeeps.sqlite"];

    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:options
                                                           error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.

         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.

         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.


         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]

         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {

    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];

    [navigationController release];
    [window release];
    [super dealloc];
}


@end

