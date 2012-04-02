//
//  Truck.h
//  NomadTruck
//
//  Created by Sandia Ren on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Truck : NSObject{
    NSString *userObjectID;
    NSString *truckObjectID;
}
@property (nonatomic, retain) NSString *userObjectID;
@property (nonatomic, retain) NSString *truckObjectID;
@property (nonatomic, retain) NSString *parseID;
@property (nonatomic, strong) NSMutableArray *salesData;
@property (nonatomic, assign) BOOL loadingTruckData;

+ (Truck *)sharedTruck;
+ (NSMutableArray*)getSalesData;
+ (void) loadTruckFromParse;
+ (void) waitForLoading;

@end
