//
//  InventoryTableViewController.h
//  NomadTruck
//
//  Created by Farley User on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryTableViewController : UITableViewController <UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *daySalesData;
@property (nonatomic, assign) int daySalesIndex;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (nonatomic, strong) NSString *sender;
@property (weak, nonatomic) IBOutlet UITextField *DateInput;

- (void)textFieldDidEndEditing:(UITextView *)textField;

@end
