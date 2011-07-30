//
//  AddItemViewController.h
//  ShoppingList
//
//  Created by Piet Brauer on 22.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemViewController : UIViewController <UITextFieldDelegate>{
    IBOutlet UITextField *name;
    IBOutlet UIButton *add;
    IBOutlet UIButton *cancel;
    NSString *tableName;
}

@property (nonatomic, retain) UITextField *name;
@property (nonatomic, retain) UIButton *add;
@property (nonatomic, retain) UIButton *cancel;
@property (nonatomic, retain) NSString *tableName;

-(void)close:(id)sender;
-(void)add:(id)sender;

@end
