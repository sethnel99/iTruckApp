//
//  Truck.m
//  NomadTruck
//
//  Created by Sandia Ren on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Truck.h"
#import "MenuFoodItem.h"
#import "NomadTruckViewController.h"

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
@synthesize salesDataByItem;

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

+ (NSMutableDictionary *) getSalesDataByItem{
    return sharedTruck.salesDataByItem;
}



/*+ (double) priceForInventoryItem:(NSString *) menuItemID{
    MenuFoodItem *item;// = [sharedTruck.inventory objectAtIndex:index];
    for(int i = 0; i < [sharedTruck.inventory count]; i++){
        item = [sharedTruck.inventory objectAtIndex:i];
        if([item.ParseID isEqualToString:menuItemID])
            return item.price;
    }
    NSLog(@"price for inventory item that did not exist");
    return 0;
}*/

+ (void) updateSalesEntry:(NSMutableArray *)entrySales onEntryIndex:(int)index{
    [sharedTruck.salesData replaceObjectAtIndex:index withObject:entrySales];
    [self rebuildSalesEntryByDay];
    [self rebuildSalesEntryByItem];
    [self saveSalesToParse];
}

+ (void) deleteSalesEntryAtIndex:(int) index{
    [sharedTruck.salesData removeObjectAtIndex:index];
    [self rebuildSalesEntryByDay];
    [self rebuildSalesEntryByItem];
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
            [self rebuildSalesEntryByItem];
            [self saveSalesToParse];
            return;
        }
        
        
    }
    
    //get to the end - this is the latest (most recent) object
    [sharedTruck.salesData addObject:entrySales];
    [self rebuildSalesEntryByDay];
    [self rebuildSalesEntryByItem];
    [self saveSalesToParse];
}


+ (void) rebuildSalesEntryByDay{

    //set up sales organized by day//
    sharedTruck.salesDataByDay = [[NSMutableArray alloc] init];
    if([sharedTruck.salesData count] == 0)
        return;
    
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

+ (void) rebuildSalesEntryByItem{
    //set up sales organized by item//
    sharedTruck.salesDataByItem = [[NSMutableDictionary alloc] init];
    if([sharedTruck.salesData count] == 0)
        return;
    
    
    for(int i = 0; i < [sharedTruck.salesData count]; i++){
        NSArray *salesRecord = [sharedTruck.salesData objectAtIndex:i];
        for(int j = 2; j < [salesRecord count]; j++){
            NSMutableArray *dataPoint = [salesRecord objectAtIndex:j];
            NSMutableArray *array = [sharedTruck.salesDataByItem objectForKey:[dataPoint objectAtIndex:1]]; //keyed by datapoints's parseID
            if(array == nil){
                array = [NSMutableArray arrayWithObject:dataPoint];
                [sharedTruck.salesDataByItem setObject:array forKey:[dataPoint objectAtIndex:1]];
            }else{
                [array addObject:dataPoint]; 
            }
            
        }
    }
    
    
}

+ (void) saveSalesToParse{
    [sharedTruck.truckPFObject setObject:sharedTruck.salesData forKey:@"SalesData"];
    [sharedTruck.truckPFObject saveInBackground];
}

+ (void) loadTruckFromParse:(UIViewController *)sender
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Trucks"];
    PFCachePolicy cachePolicy = kPFCachePolicyNetworkElseCache;
    query.cachePolicy = cachePolicy;
    [query whereKey:@"UserObjectID" equalTo:sharedTruck.userObjectID];
    
   
    
    sharedTruck.truckPFObject = [query getFirstObject];
    
    if(sharedTruck.truckPFObject == nil){
        sharedTruck.loadingTruckData = false;
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [(NomadTruckViewController *)sender exitWithTitle: @"Please sign up on our website!"
                withMessage: @"We require that you register on our website before you can begin using this application. Please visit www.nomadgo.com. Thank you!"];
        });
        NSLog(@"shit login");
    }
    
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
        NSNumber *cost = [temp objectForKey:@"Cost"];
        double dcost = 0;
        //quick error check: make sure there is a cost - otherwise 0
        if(cost != [NSNull null])
            dcost = [cost doubleValue];
        
        double price = [[temp objectForKey:@"Price"] doubleValue];
        [menuData addObject:[[MenuFoodItem alloc] initWithParseID:ParseID withName:name withCost:dcost withPrice:price]];
        
    }
    sharedTruck.inventory = menuData;
    //end load inventory//
    
    NSArray *dl = [sharedTruck.truckPFObject objectForKey:@"SalesData"];
     
    if(dl == [NSNull null]){
        sharedTruck.salesData = [[NSMutableArray alloc] init]; 
    }else{
        sharedTruck.salesData = [[NSMutableArray alloc] initWithArray:dl];
    }   
 
    [self rebuildSalesEntryByDay];
    [self rebuildSalesEntryByItem];
    sharedTruck.loadingTruckData = false;

}

+ (void) waitForLoading{
        while(sharedTruck.loadingTruckData == YES){
            [NSThread sleepForTimeInterval:1];
        }
   
}

+ (double) getTotalProfit{
    double totalProfit = 0;
    //sum up sales for each entry
    for(int i = 0; i < [sharedTruck.salesData count]; i++){
        NSMutableArray *singleEntry = [sharedTruck.salesData objectAtIndex:i];
        for(int j = 2; j < [singleEntry count]; j++){
            NSArray *dataPoint = [singleEntry objectAtIndex:j];
            totalProfit += [[dataPoint objectAtIndex:2] intValue]*([[dataPoint objectAtIndex:3] doubleValue] - [[dataPoint objectAtIndex:4] doubleValue]); //profit = numSold * (price-cost)
        }
    }
    
    return totalProfit;
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

+ (NSString *)getAffixForDay:(int)day{
    if (day == 1)
        return @"st";
    else if (day == 2)
        return @"nd";
    else if (day == 3)
        return @"rd";
    else {
        return @"th";
    }
}



@end
