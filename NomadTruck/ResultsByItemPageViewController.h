//
//  ResultsByItemPageViewController.h
//  NomadTruck
//
//  Created by Farley User on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsByItemPageViewController : UIPageViewController  <UIGestureRecognizerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *allKeys;
@property (nonatomic, strong) NSMutableDictionary *salesDataByItem;
@property (nonatomic, strong) NSMutableArray *salesCalculationsByItem;
@property (nonatomic, strong) NSMutableDictionary *myViewControllers;
@property (nonatomic, assign) NSString *currentKey;

+(int)numberOfXDays:(int)dayOfWeek withStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate;

@end
