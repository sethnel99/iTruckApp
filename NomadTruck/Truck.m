//
//  Truck.m
//  NomadTruck
//
//  Created by Sandia Ren on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Truck.h"
#import "Parse/Parse.h"

static Truck *sharedTruck = nil;

@implementation Truck

@synthesize userObjectID;
@synthesize truckObjectID;
@synthesize parseID;
@synthesize salesData;
@synthesize loadingTruckData;

#pragma mark 
#pragma mark Singleton Methods
+ (Truck *)sharedTruck {
    if(sharedTruck == nil){
        sharedTruck = [[[self class] alloc] init];
    }
    return sharedTruck;
}

+ (NSMutableArray *) getSalesData{
    return sharedTruck.salesData;
}

+ (void) loadTruckFromParse{
    
    sharedTruck.salesData = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Trucks"];
    PFCachePolicy cachePolicy = kPFCachePolicyNetworkElseCache;
    query.cachePolicy = cachePolicy;
    
    //placeholder query until twitter accounts are linked to trucks
    [query whereKey:@"userObjectID"equalTo:@"A5pACN1qDB"];
    
    PFObject *parseTruck = [query getFirstObject];
    sharedTruck.parseID = parseTruck.objectId;
    
    NSMutableArray *salesData = [[NSMutableArray alloc] initWithArray:[parseTruck objectForKey:@"SalesData"]];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    ////////////initializing nonsense to fill in empty days/////////
    
    //if there is no sales data, start with today
    if([salesData count] == 0){
        //populate a day
   
        NSArray *dataPoint = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:[components day]],[NSNumber numberWithInt:[components month]],[NSNumber numberWithInt:[components year]], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
        
        NSLog([NSString stringWithFormat:@"d: %d i: %i",[dataPoint objectAtIndex:0],[dataPoint objectAtIndex:0]]);
        
        [salesData addObject:dataPoint];
    }else{
    //if there is sales data, fill in up to today 
        
        NSArray *lastDataPoint = [salesData lastObject];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMdd"];
        NSDate *lastDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@%@%@",[lastDataPoint objectAtIndex:2],[lastDataPoint objectAtIndex:1],[lastDataPoint objectAtIndex:0]]];
        NSDateComponents *lastComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:lastDate];
        
        while([lastComponents year] != [components year] || [lastComponents month] != [components month] || [lastComponents day] != [components day]){
            
            NSArray *dataPoint = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:[lastComponents day]],[NSNumber numberWithInt:[lastComponents month]],[NSNumber numberWithInt:[lastComponents year]], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
            
            [salesData addObject:dataPoint];
            
            lastDate = [lastDate dateByAddingTimeInterval:86400];
            lastComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:lastDate];
        }
        
    }
    //////////////end of nonsense////////////////////////
    
    sharedTruck.salesData = salesData;

    sharedTruck.loadingTruckData = false;

}

+ (void) waitForLoading{
        while(sharedTruck.loadingTruckData == YES){
            [NSThread sleepForTimeInterval:1];
        }
   
}



@end
