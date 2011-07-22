//
//  ShoppingListAppDelegate.m
//  ShoppingList
//
//  Created by Piet Brauer on 22.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShoppingListAppDelegate.h"
#import <sqlite3.h>

@implementation ShoppingListAppDelegate

NSString *DATABASE_RESOURCE_NAME = @"ShoppingList";
NSString *DATABASE_RESOURCE_TYPE = @"db";
NSString *DATABASE_FILE_NAME = @"ShoppingList.db";

@synthesize window = _window, dbFilePath;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //NavigationController erstellen zum managen der TableViews
    navigationController = [[UINavigationController alloc] init];
    
    //MainView erstellen und dem NavigationController hinzufügen
    mainView = [[MainView alloc] initWithStyle:UITableViewStyleGrouped];
    [navigationController pushViewController:mainView animated:NO];
    
    //navigationController anzeigen
    [self.window addSubview:navigationController.view];

    [self.window makeKeyAndVisible];
    
    //Datenbank initialisieren
    if(! [self initializeDb]) {
		NSLog (@"couldn't init db");
	}
    
    return YES;
}

#pragma mark - SQlite

- (BOOL) initializeDb {
	// nach Datenbank suchen, anderenfalls im Backup Ordner nachsehen
	NSArray *searchPaths =
    NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
	dbFilePath = [documentFolderPath stringByAppendingPathComponent:
				  DATABASE_FILE_NAME];
    
	if (! [[NSFileManager defaultManager] fileExistsAtPath: dbFilePath]) {
		// aus Backup kopieren
		NSString *backupDbPath = [[NSBundle mainBundle]
                                  pathForResource:DATABASE_RESOURCE_NAME
                                  ofType:DATABASE_RESOURCE_TYPE];
		if (backupDbPath == nil) {
			// backup Pfad leer
			return NO;
		} else {
			BOOL copiedBackupDb = [[NSFileManager defaultManager]
                                   copyItemAtPath:backupDbPath
                                   toPath:dbFilePath
                                   error:nil];
			if (! copiedBackupDb) {
				// kopieren des Backups fehlgeschlagen
				return NO;
			}
		}
	}
	return YES;
}

@end
