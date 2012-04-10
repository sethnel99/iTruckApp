//
//  CustomInventoryInputCell.m
//  NomadTruck
//
//  Created by Farley User on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomInventoryInputCell.h"

@implementation CustomInventoryInputCell
@synthesize textTag;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
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

@end
