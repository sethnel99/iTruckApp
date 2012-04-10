//
//  InventoryDateTableViewController.h
//  NomadTruck
//
//  Created by Farley User on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface InventoryDateTableViewController : UITableViewController <MBProgressHUDDelegate>

@property (nonatomic, strong) NSMutableArray *salesData;
@end
