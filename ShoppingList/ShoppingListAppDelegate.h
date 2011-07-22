//
//  ShoppingListAppDelegate.h
//  ShoppingList
//
//  Created by Piet Brauer on 22.07.11.
//  Copyright 2011 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainView.h"

@interface ShoppingListAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>
{
    MainView *mainView;
    UINavigationController *navigationController;
    NSString *dbFilePath;
}

-(BOOL)initializeDb;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSString *dbFilePath;

@end
