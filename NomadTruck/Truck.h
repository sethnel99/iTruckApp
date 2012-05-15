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
@property (nonatomic, retain) NSString *userObjectID; //twitter ID
@property (nonatomic, retain) NSString *truckObjectID; //truck Parse ID
@property (nonatomic, retain) NSString *name; //truck's name
@property (nonatomic, strong) NSArray *inventory; //truck's inventory
@property (nonatomic, strong) NSMutableArray *salesData; //array of sales entries
@property (nonatomic, strong) NSMutableArray *salesDataByDay; //sales entries by day
@property (nonatomic, assign) BOOL loadingTruckData; //true = loading in background 
@property (nonatomic, strong) PFObject *truckPFObject; //PFObject for truck
@property (nonatomic, strong) NSData *truckLogo; //truck's logos


+ (Truck *)sharedTruck;
+ (void) loadTruckFromParse:(UIViewController *)sender;
+ (void) saveSalesToParse;
+ (NSMutableArray *) getInventory;
+ (NSMutableArray *) getSalesData;
+ (NSMutableArray *) getSalesDataByDay;
+ (void) deleteSalesEntryAtIndex:(int) index;
+ (void) addSalesEntry:(NSMutableArray *)entrySales;
+ (void) updateSalesEntry:(NSMutableArray *)entrySales onEntryIndex:(int)index;
+ (void) rebuildSalesEntryByDay;
+ (void) waitForLoading;
+ (double) priceForInventoryItem:(NSString *)menuItemID;
+ (double) getTotalMoney;
+ (UIColor *)getTealGreenTint;
+ (CAGradientLayer *)getTitleBarGradientWithFrame:(CGRect)frame;
+ (CAGradientLayer *)getCellGradientWithFrame:(CGRect)frame;
+ (NSString *)getAffixForDay:(int)day;
@end
