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
@synthesize name;
@synthesize inventory;
@synthesize loadingTruckData;
@synthesize salesData;
@synthesize truckPFObject;
@synthesize truckLogo;
@synthesize salesDataByDay;

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

+ (NSMutableArray *) getSalesData{
    return sharedTruck.salesData;
}

+ (NSMutableArray *) getSalesDataByDay{
    return sharedTruck.salesDataByDay;
}



+ (double) priceForInventoryItem:(int)index{
    MenuFoodItem *item = [sharedTruck.inventory objectAtIndex:index];
    return item.price;
}

+ (void) updateSalesEntry:(NSMutableArray *)entrySales onEntryIndex:(int)index{
    [sharedTruck.salesData replaceObjectAtIndex:index withObject:entrySales];
    [self rebuildSalesEntryByDay];
    [self saveSalesToParse];
}

+ (void) deleteSalesEntryAtIndex:(int) index{
    [sharedTruck.salesData removeObjectAtIndex:index];
    [self rebuildSalesEntryByDay];
    [self saveSalesToParse];
}
+ (void) addSalesEntry:(NSMutableArray *)entrySales{
    NSDate *newSaleDate = [entrySales objectAtIndex:0];
    
    //loop through the existing sales day entries to place this one in the correct chronological order
    for(int i = 0; i < [sharedTruck.salesData count]; i++){
        NSMutableArray *tArr = [sharedTruck.salesData objectAtIndex:i];
        NSDate *tDate = (NSDate*)[tArr objectAtIndex:0];
        if([tDate compare:newSaleDate] == NSOrderedDescending){
            [sharedTruck.salesData insertObject:entrySales atIndex:i];
            [self rebuildSalesEntryByDay];
            [self saveSalesToParse];
            return;
        }
        
        
    }
    
    //get to the end - this is the latest (most recent) object
    [sharedTruck.salesData addObject:entrySales];
    [self saveSalesToParse];
}

+ (void) updateAveragesWithMoney:(double)money{
    
}

+ (void) rebuildSalesEntryByDay{

    //set up sales organized by day//
    sharedTruck.salesDataByDay = [[NSMutableArray alloc] init];
    
    [sharedTruck.salesDataByDay addObject:[NSMutableArray arrayWithObject:[sharedTruck.salesData objectAtIndex:0]]];
    for(int i = 1; i < [sharedTruck.salesData count]; i++){
        NSMutableArray *singleDayData = [sharedTruck.salesData objectAtIndex:i];
        NSDate *tempDate = (NSDate*)[singleDayData objectAtIndex:0];
        
        NSMutableArray *lastEntry = [sharedTruck.salesData objectAtIndex:(i-1)];
        NSDate *lastDate = (NSDate*)[lastEntry objectAtIndex:0];
        
        
        NSDateComponents *thisComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:tempDate];
        
        NSDateComponents *lastComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:lastDate];
        
        //same day
        if(([thisComponents month] == [lastComponents month])&&([thisComponents day] == [lastComponents day]) && ([thisComponents year] == [lastComponents year])){
            [[sharedTruck.salesDataByDay lastObject] addObject:singleDayData];
        }else{
            [sharedTruck.salesDataByDay addObject:[NSMutableArray arrayWithObject:singleDayData]]; 
        }
        
        
        
        
        
    }
    //end sales organized by day setup
    
    
    
    
}

+ (void) saveSalesToParse{
    [sharedTruck.truckPFObject setObject:sharedTruck.salesData forKey:@"SalesData"];
    [sharedTruck.truckPFObject saveInBackground];
}

+ (void) loadTruckFromParse{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Trucks"];
    PFCachePolicy cachePolicy = kPFCachePolicyNetworkElseCache;
    query.cachePolicy = cachePolicy;
    [query whereKey:@"UserObjectID" equalTo:sharedTruck.userObjectID];
    
   
    
    sharedTruck.truckPFObject = [query getFirstObject];
    
    
    //load some general stuff 
    sharedTruck.truckObjectID = sharedTruck.truckPFObject.objectId;
  
    
    NSLog(@"userobjectID %@",sharedTruck.userObjectID);

        sharedTruck.truckObjectID = sharedTruck.truckPFObject.objectId;
            
        NSLog(@"global truckObjectID %@",sharedTruck.truckObjectID);
            
        sharedTruck.name = [sharedTruck.truckPFObject objectForKey:@"Name"];
        PFFile *truckLogoFromParse = [sharedTruck.truckPFObject objectForKey:@"Logo"];
        sharedTruck.truckLogo = [truckLogoFromParse getData];
    
    //end load general stuff
    
    //////load inventory//////////
    PFQuery *queryMenuItems = [PFQuery queryWithClassName:@"MenuItems"];
    [queryMenuItems whereKey:@"TruckID" equalTo:sharedTruck.truckObjectID];
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
    //end load inventory//
    
    sharedTruck.salesData = [[NSMutableArray alloc] initWithArray:[sharedTruck.truckPFObject objectForKey:@"SalesData"]];
    
 
    
    
    [self rebuildSalesEntryByDay];
    sharedTruck.loadingTruckData = false;

}

+ (void) waitForLoading{
        while(sharedTruck.loadingTruckData == YES){
            [NSThread sleepForTimeInterval:1];
        }
   
}

+ (double) getTotalMoney{
    double totalMoney = 0;
    //sum up sales for each entry
    for(int i = 0; i < [sharedTruck.salesData count]; i++){
        NSMutableArray *singleEntry = [sharedTruck.salesData objectAtIndex:i];
        for(int j = 2; j < [singleEntry count]; j++){
            NSArray *dataPoint = [singleEntry objectAtIndex:j];
            totalMoney += [[dataPoint objectAtIndex:2] intValue]*[Truck priceForInventoryItem:(j-2)];
        }
    }
    
    return totalMoney;
}

+ (UIColor *)getTealGreenTint{
    return [UIColor colorWithRed:.184 green:.565 blue:.514 alpha:1];
}

+ (CAGradientLayer *)getTitleBarGradientWithFrame:(CGRect)frame{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1] CGColor],[[UIColor colorWithRed:.42 green:.42 blue:.42 alpha:1] CGColor], (id)[[UIColor colorWithRed:.38 green:.38 blue:.38 alpha:1.0] CGColor],[[UIColor colorWithRed:.28 green:.28 blue:.28 alpha:1.0] CGColor], nil];
    gradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithDouble:0.0],[NSNumber numberWithDouble:.5],[NSNumber numberWithDouble:.51],[NSNumber numberWithDouble:1.0], nil];
   
    return gradient;
    
}

+ (CAGradientLayer *)getCellGradientWithFrame:(CGRect)frame{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:.875 green:.875 blue:.875 alpha:1] CGColor], (id)[[UIColor whiteColor] CGColor], nil];

    return gradient;
}


@end
