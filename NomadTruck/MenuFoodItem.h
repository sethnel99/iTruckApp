//
//  MenuFoodItem.h
//  NomadClient
//
//  Created by Farley User on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuFoodItem : NSObject

@property (nonatomic, strong) NSString *ParseID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double price;


- (MenuFoodItem *)initWithParseID:(NSString *)pID
                         withName:(NSString *)n
                        withPrice:(double)p;


@end
