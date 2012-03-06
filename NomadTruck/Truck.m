//
//  Truck.m
//  NomadTruck
//
//  Created by Sandia Ren on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Truck.h"

static Truck *sharedTruck = nil;

@implementation Truck

@synthesize userObjectID;
@synthesize truckObjectID;

#pragma mark -
#pragma mark Singleton Methods
+ (Truck *)sharedTruck {
    if(sharedTruck == nil){
        sharedTruck = [[[self class] alloc] init];
    }
    return sharedTruck;
}

@end
