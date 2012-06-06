//
//  CustomInventoryInputCell.m
//  NomadTruck
//
//  Created by Farley User on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomInventoryInputCell.h"

static CustomInventoryInputCell *activeCell = nil;

@implementation CustomInventoryInputCell
@synthesize textTag;
@synthesize keyboardHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) prepareForReuse {
    UITextField *tempTextField = (UITextField*)[self viewWithTag:self.textTag];
    tempTextField.tag = 102;
}

-(BOOL)resignFirstResponder
{   
    [[self viewWithTag:self.textTag] resignFirstResponder];  
    return [super resignFirstResponder];
}


-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    // check to see if the hit is in this cell 
    if ([self pointInside:point withEvent:event]) {
        if(point.y <  self.superview.frame.size.height - self.keyboardHeight){
            [activeCell resignFirstResponder];
            activeCell = self;   
        }
        
    }
    
    // return the super's hitTest result
    return [super hitTest:point withEvent:event];   
}  

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.keyboardHeight = kbSize.height;
    
}

- (void)keyboardWasHidden:(NSNotification*)aNotification
{
    self.keyboardHeight = 0;
    
}







@end
