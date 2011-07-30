//
//  ItemTableView.h
//  ShoppingList
//
//  Created by Piet Brauer on 22.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListAppDelegate.h"
#import <sqlite3.h>

@interface ItemTableView : UITableViewController{
    NSString *tableName;
}

@property (nonatomic, retain) NSString *tableName;

-(void)addItem:(id)sender;
-(void)loadItems;
@end
