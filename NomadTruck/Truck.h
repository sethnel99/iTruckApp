//
//  Truck.h
//  NomadTruck
//
//  Created by Sandia Ren on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Truck : NSObject{
    NSString *userObjectID;
    NSString *truckObjectID;
}
@property (nonatomic, retain) NSString *userObjectID;
@property (nonatomic, retain) NSString *truckObjectID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, strong) NSArray *inventory;
@property (nonatomic, strong) NSMutableArray *salesData;
@property (nonatomic, assign) BOOL loadingTruckData;
@property (nonatomic, strong) PFObject *truckPFObject;
@property (nonatomic, strong) NSData *truckLogo;

+ (Truck *)sharedTruck;
+ (void) loadTruckFromParse;
+ (NSMutableArray *) getInventory;
+ (NSMutableArray *) getSalesData;
+ (void) deleteSalesDayAtIndex:(int) index;
+ (void) addSalesDay:(NSMutableArray *)daySales;
+ (void) updateSalesDay:(NSMutableArray *)daySales onDayIndex:(int)index;
+ (void) waitForLoading;
+ (double) priceForInventoryItem:(int)index;

@end
