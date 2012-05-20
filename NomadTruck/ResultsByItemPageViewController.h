//
//  ResultsByItemPageViewController.h
//  NomadTruck
//
//  Created by Farley User on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsByItemPageViewController : UIPageViewController  <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *allKeys;
@property (nonatomic, strong) NSMutableDictionary *salesDataByItem;

@end
