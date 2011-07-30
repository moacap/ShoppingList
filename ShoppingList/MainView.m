//
//  MainView.m
//  ShoppingList
//
//  Created by Piet Brauer on 22.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainView.h"
#import "sqlite3.h"
#import "ShoppingListAppDelegate.h"
#import "ItemTableView.h"
#import "AddListViewController.h"



@implementation MainView

NSMutableArray *tables;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Add Button hinzufügen
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddListViewController:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    //beim Anzeigen des View alle Tables laden
    [self loadTables];
    //TableView neuladen
    [self.tableView reloadData];
    //Titel für die NavigationBar setzen
    [self.navigationItem setTitle:@"Lists"];
    
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Anzahl der Tables = Anzahl Zellen
    return [tables count];
    NSLog(@"%i",[tables count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //TextLabel der Zelle bekommt den Namen der Tables
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[tables objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Beim berühren einer Zelle wird der ItemTableView angezeigt
     ItemTableView *detailViewController = [[ItemTableView alloc] initWithNibName:nil bundle:nil];
    [detailViewController setTableName:[NSString stringWithFormat:@"%@",[tables objectAtIndex:indexPath.row]]];
     [self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)showAddListViewController:(id)sender{
    AddListViewController *viewController = [[AddListViewController alloc] init];
    [viewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentModalViewController:viewController animated:YES];
}

#pragma mark - SQlite

-(void)loadTables{
    
    sqlite3 *db;
	int dbrc; // database return code
	ShoppingListAppDelegate *appDelegate = (ShoppingListAppDelegate*)[UIApplication sharedApplication].delegate;
    
	const char* dbFilePathUTF8 = [appDelegate.dbFilePath UTF8String];
	dbrc = sqlite3_open (dbFilePathUTF8, &db);
	if (dbrc) {
		NSLog (@"couldn't open db:");
		return;
	}
	
	// select stuff
	sqlite3_stmt *dbps; // database prepared statement
    
    //jede SQLite Datenbank besitzt eine sql_master Tabelle aus der die Tabellennamen hervorgehen
	NSString *queryStatementNS = @"select tbl_name from sqlite_master where type = 'table'";
    
    
	const char *queryStatement = [queryStatementNS UTF8String];
	dbrc = sqlite3_prepare_v2 (db, queryStatement, -1, &dbps, NULL);
	
	// at this point, clear out any existing table model array and prepare new one
	tables = [[NSMutableArray alloc] init];
	
	// repeatedly execute the prepared statement until we're out of results
	while ((dbrc = sqlite3_step (dbps)) == SQLITE_ROW) {
        NSString *table = [NSString stringWithUTF8String:(char*)sqlite3_column_text(dbps, 0)];
        
        [tables addObject:table];
	}
    
	// done with the db.  finalize the statement and close
	sqlite3_finalize (dbps);
	sqlite3_close(db);
}

@end
