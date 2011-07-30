//
//  AddItemViewController.m
//  ShoppingList
//
//  Created by Piet Brauer on 22.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddItemViewController.h"
#import "ShoppingListAppDelegate.h"
#import <sqlite3.h>

@implementation AddItemViewController
@synthesize name, cancel, add, tableName;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [add addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [cancel addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [name setDelegate:self];
    
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)close:(id)sender{
    [self dismissModalViewControllerAnimated:YES];    
}

-(void)add:(id)sender{
    if ([name.text length] != 0) {
        sqlite3 *db;
        int dbrc; // database return code
        
        ShoppingListAppDelegate *appDelegate = (ShoppingListAppDelegate*)[UIApplication sharedApplication].delegate;
        
        const char* dbFilePathUTF8 = [appDelegate.dbFilePath UTF8String];
        dbrc = sqlite3_open (dbFilePathUTF8, &db);
        if (dbrc) {
            NSLog (@"couldn't open db:");
            return;
        }
        
        // insert stuff
        sqlite3_stmt *dbps; // database prepared statement
        
        //insert statement
        NSString *createStatementNS = [NSString stringWithFormat:@"INSERT INTO \"%@\" (item, bool) VALUES (\"%@\",0)",tableName,name.text]; //ID wird automatisch erstellt
        //convert in char
        const char*createStatement = [createStatementNS UTF8String];
        
        dbrc = sqlite3_prepare_v2(db, createStatement, -1, &dbps, NULL);
        dbrc = sqlite3_step (dbps);
        
        // done with the db.  finalize the statement and close
        sqlite3_finalize (dbps);
        sqlite3_close(db);
        
        [self dismissModalViewControllerAnimated:YES]; //View freigeben, minimieren
    } else {
        //wird aufgerufen, wenn das Feld nichts enthält
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please insert a Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [name resignFirstResponder];
    return NO;
}
@end
