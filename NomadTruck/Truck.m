//
//  Truck.m
//  NomadTruck
//
//  Created by Sandia Ren on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Truck.h"
#import "MenuFoodItem.h"

static Truck *sharedTruck = nil;

@implementation Truck

@synthesize userObjectID;
@synthesize truckObjectID;
@synthesize parseID;
@synthesize inventory;
@synthesize loadingTruckData;
@synthesize salesData;
@synthesize truckPFObject;
#pragma mark 
#pragma mark Singleton Methods
+ (Truck *)sharedTruck {
    if(sharedTruck == nil){
        sharedTruck = [[[self class] alloc] init];
    }
    return sharedTruck;
}

+ (NSArray *) getInventory{
    return sharedTruck.inventory;
}

+ (NSArray *) getSalesData{
    return sharedTruck.salesData;
}

+ (void) updateSalesDay:(NSMutableArray *)daySales onDayIndex:(int)index{
    [sharedTruck.salesData replaceObjectAtIndex:index withObject:daySales];
    [self saveSalesToParse];
}

+ (void) deleteSalesDayAtIndex:(int) index{
    [sharedTruck.salesData removeObjectAtIndex:index];
    [self saveSalesToParse];
}
+ (void) addSalesDay:(NSMutableArray *)daySales{
    NSDate *newSaleDate = [daySales objectAtIndex:0];
    
    //loop through the existing sales day entries to place this one in the correct chronological order
    for(int i = 0; i < [sharedTruck.salesData count]; i++){
        NSMutableArray *tArr = [sharedTruck.salesData objectAtIndex:i];
        NSDate *tDate = (NSDate*)[tArr objectAtIndex:0];
        if([tDate compare:newSaleDate] == NSOrderedDescending){
            [sharedTruck.salesData insertObject:daySales atIndex:i];
            return;
        }
        
        [self saveSalesToParse];
    }
    
    //get to the end - this is the latest (most recent) object
    [sharedTruck.salesData addObject:daySales];
}

+ (void) saveSalesToParse{
    [sharedTruck.truckPFObject setObject:sharedTruck.salesData forKey:@"SalesData"];
    [sharedTruck.truckPFObject saveInBackground];
}

+ (void) loadTruckFromParse{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Trucks"];
    PFCachePolicy cachePolicy = kPFCachePolicyNetworkElseCache;
    query.cachePolicy = cachePolicy;
    
    //placeholder query until twitter accounts are linked to trucks
    [query whereKey:@"UserObjectID"equalTo:@"eDBqNUx1lc"];
    
    sharedTruck.truckPFObject = [query getFirstObject];
    sharedTruck.parseID = sharedTruck.truckPFObject.objectId;
    //NSArray *rawSD = [parseTruck objectForKey:@"SalesData"];
    NSMutableArray *salesData = [[NSMutableArray alloc] initWithArray:[sharedTruck.truckPFObject objectForKey:@"SalesData"]];
    
   
    
    
    
    //////load inventory//////////
    PFQuery *queryMenuItems = [PFQuery queryWithClassName:@"MenuItems"];
    [queryMenuItems whereKey:@"TruckID" equalTo:sharedTruck.parseID];
    queryMenuItems.cachePolicy = cachePolicy;
    
    NSArray* parseData = [queryMenuItems findObjects];
    NSMutableArray *menuData = [[NSMutableArray alloc] init];
    for(PFObject *temp in parseData){
        NSString *ParseID = temp.objectId;
        NSString *name = [temp objectForKey:@"Name"];
        double price = [[temp objectForKey:@"Price"] doubleValue];
        [menuData addObject:[[MenuFoodItem alloc] initWithParseID:ParseID withName:name withPrice:price]];
        
    }
    sharedTruck.inventory = menuData;
    
    
    //if there is no sales data, start with today (temporary)
    if([salesData count] == 0){
        
        //create a date point, which is a date followed by data for each menu item
        NSMutableArray *datePoint = [[NSMutableArray alloc] init];
        [datePoint addObject:[NSDate date]];
        [datePoint addObject:@"S. Davis and Wells"];
        
        //for each menu item, add an entry which is a name, a before, and an after number
        for(int i = 0; i < [sharedTruck.inventory count]; i++){
            [datePoint addObject:[[NSArray alloc] initWithObjects:[[sharedTruck.inventory objectAtIndex:i] name], [NSNumber numberWithInt:0], nil]];
        }
        
        NSLog([NSString stringWithFormat:@"date: %@",[datePoint objectAtIndex:0]]);
        
        [salesData addObject:datePoint];
    }

    
    
    
    sharedTruck.salesData = salesData;

    sharedTruck.loadingTruckData = false;

}

+ (void) waitForLoading{
        while(sharedTruck.loadingTruckData == YES){
            [NSThread sleepForTimeInterval:1];
        }
   
}



@end
