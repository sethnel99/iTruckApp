//
//  main.m
//  NomadTruck
//
//  Created by Sandia Ren on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NomadTruckAppDelegate.h"
#import <Parse/Parse.h>

int main(int argc, char *argv[])
{
    [Parse setApplicationId:@"FoX2hKFWtiUIWgt2mioFIJvwdwgy461XAS7n367S" 
                  clientKey:@"EU6d1ccuc3rUiW09IXqnLGF8XNngazVCWZDvSfC1"];
    [PFTwitterUtils initializeWithConsumerKey:@"nI8I27q2uOJVgN5rrEnnQ"
                               consumerSecret:@"cb987wribwLK991Qj3jwaIdsBHvr9mHp10G0D0JpVo"];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([NomadTruckAppDelegate class]));
    }
}