//
//  MenuFoodItem.m
//  NomadClient
//
//  Created by Farley User on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuFoodItem.h"

@implementation MenuFoodItem

@synthesize ParseID;
@synthesize name;
@synthesize price;


- (MenuFoodItem *)initWithParseID:(NSString *)pID
                         withName:(NSString *)n
                        withPrice:(double)p{
    
    if(self = [super init]){
        self.ParseID = pID;
        self.name = n;
        self.price = p;
    }
    return self;
    
}


@end
