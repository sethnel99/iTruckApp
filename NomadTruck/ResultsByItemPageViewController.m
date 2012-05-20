//
//  ResultsByItemPageViewController.m
//  NomadTruck
//
//  Created by Farley User on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResultsByItemPageViewController.h"
#import "ResultsByItemViewController.h"
#import "Truck.h"


@interface ResultsByItemPageViewController ()

@end

@implementation ResultsByItemPageViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
 
    
}

- (void)viewDidAppear:(BOOL)animated{

    self.salesDataByItem = [Truck getSalesDataByItem];
    self.allKeys = [self.salesDataByItem allKeys];
    
    ResultsByItemViewController *rbivc = [[UIStoryboard storyboardWithName:@"MainStoryboard"
                                                                    bundle: nil]instantiateViewControllerWithIdentifier:@"ResultsByItemViewController"];
    
    rbivc.keyNumber = 0;
    rbivc.itemSalesData = [self.salesDataByItem objectForKey:[self.allKeys objectAtIndex:0]];

    
    [self setViewControllers:[NSArray arrayWithObject:rbivc]
                                            direction: UIPageViewControllerNavigationDirectionForward
                                             animated:YES
                                           completion:nil
                              ];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
}

@end
