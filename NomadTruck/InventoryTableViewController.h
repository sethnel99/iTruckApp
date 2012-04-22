//
//  InventoryTableViewController.h
//  NomadTruck
//
//  Created by Farley User on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryTableViewController : UITableViewController <UIAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *titleLabelView;
@property (weak, nonatomic) IBOutlet UIView *inputBackgroundUIView;
@property (weak, nonatomic) IBOutlet UIView *TableHeadingsBackgroundView;



@property (nonatomic, strong) NSMutableArray *entrySalesData;
@property (nonatomic, assign) int entrySalesIndex;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (nonatomic, strong) NSString *sender;
@property (weak, nonatomic) IBOutlet UITextField *DateInput;

- (void)textFieldDidEndEditing:(UITextView *)textField;

@end
