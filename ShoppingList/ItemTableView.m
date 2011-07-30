//
//  ItemTableView.m
//  ShoppingList
//
//  Created by Piet Brauer on 22.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemTableView.h"
#import "AddItemViewController.h"


@implementation ItemTableView

NSMutableArray *items;

@synthesize tableName;
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)]; //plus button rechts oben hinzufügen und methode zuweisen
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadItems]; //select
    [self.tableView reloadData]; //reload input Views
    [self.navigationItem setTitle:tableName]; //NavigationController Title setzen
    
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
    // Return the number of rows in the section.
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //Keine Farbe beim Auswählen
    }
    NSLog(@"item: %@ value: %@",[[items objectAtIndex:indexPath.row] objectForKey:@"item"], [[items objectAtIndex:indexPath.row] objectForKey:@"bool"]);
    
    if ([[[items objectAtIndex:indexPath.row] objectForKey:@"bool"] intValue] == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark; //Häckchen am rechten Rand anbringen
        cell.textLabel.textColor = [UIColor grayColor]; //ausgrauen
    } else{
        cell.accessoryType = UITableViewCellAccessoryNone; //Häckchen am rechten Rand nicht setzen wenn der bool Wert 1 ist, also das Objekt eingekauft wurde
        cell.textLabel.textColor = [UIColor darkTextColor]; //schwarze Schriftfarbe
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[items objectAtIndex:indexPath.row] objectForKey:@"item"]]; //Nummer im Array anhand der Reihe raussuchen und dann den namen mit dem objekt item raussuchen
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    NSString *queryStatementNS;
    if ([[[items objectAtIndex:indexPath.row] objectForKey:@"bool"] intValue] == 0) { //wenn der Wert 0 ist, beim Touch den Wert auf 1 setzen; Database updaten 
        queryStatementNS = [NSString stringWithFormat:@"UPDATE \"%@\" SET bool = 1 WHERE item = \"%@\" AND ID = %i",tableName,[[items objectAtIndex:indexPath.row] objectForKey:@"item"],indexPath.row+1]; //Update Anweisung
    }
    
    else{ //wenn der Wert 0 ist, beim Touch den Wert auf 1 setzen; Database updaten 
        queryStatementNS = [NSString stringWithFormat:@"UPDATE \"%@\" SET bool = 0 WHERE item = \"%@\" AND ID = %i",tableName,[[items objectAtIndex:indexPath.row] objectForKey:@"item"],indexPath.row+1]; //Update Anweisung
    }

	const char *queryStatement = [queryStatementNS UTF8String];
	dbrc = sqlite3_prepare_v2 (db, queryStatement, -1, &dbps, NULL);
	
	// at this point, clear out any existing table model array and prepare new one
	items = [[NSMutableArray alloc] init];
	
	// repeatedly execute the prepared statement until we're out of results
	while ((dbrc = sqlite3_step (dbps)) == SQLITE_ROW) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        NSString *item = [NSString stringWithUTF8String:(char*)sqlite3_column_text(dbps, 1)];
        int gotInt = sqlite3_column_int(dbps, 2);
        NSNumber *got = [NSNumber numberWithInt:gotInt];
        
        [dict setObject:got forKey:@"bool"];
        [dict setObject:item forKey:@"item"];
        [items addObject:dict];
	}
    
	// done with the db.  finalize the statement and close
	sqlite3_finalize (dbps);
	sqlite3_close(db);
    [self loadItems];
    [self.tableView reloadData];
    
}

-(void)addItem:(id)sender{
    AddItemViewController *viewController = [[AddItemViewController alloc] init]; //AddView initialisieren
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical; //Übergang setzen
    [viewController setTableName:tableName];
    [self presentModalViewController:viewController animated:YES]; //AddView anzeigen
}

-(void)loadItems{
    
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
    
	NSString *queryStatementNS = [NSString stringWithFormat:@"SELECT ID, item, bool FROM \"%@\" ORDER BY ID",tableName]; //Select Anweisung
    
    
	const char *queryStatement = [queryStatementNS UTF8String];
	dbrc = sqlite3_prepare_v2 (db, queryStatement, -1, &dbps, NULL);
	
	// at this point, clear out any existing table model array and prepare new one
	items = [[NSMutableArray alloc] init];
	
	// repeatedly execute the prepared statement until we're out of results
	while ((dbrc = sqlite3_step (dbps)) == SQLITE_ROW) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

        NSString *item = [NSString stringWithUTF8String:(char*)sqlite3_column_text(dbps, 1)];
        int gotInt = sqlite3_column_int(dbps, 2);
        NSNumber *got = [NSNumber numberWithInt:gotInt];
        
        [dict setObject:got forKey:@"bool"];
        [dict setObject:item forKey:@"item"];
        [items addObject:dict];
	}
    
	// done with the db.  finalize the statement and close
	sqlite3_finalize (dbps);
	sqlite3_close(db);
}
@end
