//
//  AddListViewController.h
//  ShoppingList
//
//  Created by Piet Brauer on 22.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddListViewController : UIViewController <UITextFieldDelegate>{ //!! WICHTIG Delegate hinzufügen, sonst wird die Tastatur nicht freigegeben
    IBOutlet UITextField *name; //TextField für den Namen
    IBOutlet UIButton *cancel; //Abbruch Button
    IBOutlet UIButton *add; //Hinzufügen button
}

@property (nonatomic, retain) UITextField *name; //Getter und Setter erstellen für .xib Datei
@property (nonatomic, retain) UIButton *cancel;
@property (nonatomic, retain) UIButton *add;

-(void)close:(id)sender; //Methode zum Abbrechen
-(void)add:(id)sender; //Methode zum hinzufügen

@end
