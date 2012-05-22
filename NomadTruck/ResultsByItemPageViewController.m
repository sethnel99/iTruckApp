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
#import <stdlib.h>


@interface ResultsByItemPageViewController ()

@end

@implementation ResultsByItemPageViewController 
@synthesize allKeys;
@synthesize salesDataByItem;
@synthesize salesCalculationsByItem;
@synthesize myViewControllers;
@synthesize currentKey;

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
    self.dataSource = self;
    self.currentKey = nil;
	// Do any additional setup after loading the view.
    
 
    
}

- (void)viewDidAppear:(BOOL)animated{

    self.salesDataByItem = [Truck getSalesDataByItem];
    self.allKeys = [self.salesDataByItem allKeys];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
   
    
    //a few simple calculations (that take forever to code)
    //Calculations array: [0-7 for everyday-saturday], holding:
    //[0] = sold/day
    //[1] = profit/day
    //[2] = profit rank
    
    
    self.salesCalculationsByItem = [[NSMutableArray alloc] init];
    NSMutableArray *keyProfitPairsArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 8; i++){
        [self.salesCalculationsByItem addObject:[[NSMutableDictionary alloc] init]];
        [keyProfitPairsArray addObject:[[NSMutableOrderedSet alloc] init]];

    }
    
    //for each item
    for(int i = 0; i < [allKeys count]; i++){
        NSMutableArray *itemSalesData = [self.salesDataByItem objectForKey:[self.allKeys objectAtIndex:i]];
        
        //first date this item was sold and last date this time was sold
        NSMutableArray *firstEntry = [itemSalesData objectAtIndex:0];
        NSMutableArray *lastEntry = [itemSalesData lastObject];
        
     
        
        
        double daysSold[8];
      
        int sold[8];
        double profit[8];
        for(int q = 0; q < 8; q++){
            daysSold[q] = [ResultsByItemPageViewController numberOfXDays:q withStartDate:[firstEntry objectAtIndex:5] withEndDate:[lastEntry objectAtIndex:5]];
            if(daysSold[q] == 0) //quick error fix - if daysSold[q] = 0, then this item was never sold on this day of the week. This means that the sales/profits will be 0 anyway. So change it to 1, so 0/1 = 0 instead of 0/0 = nan.
                daysSold[q] = 1;
            sold[q]= 0;
            profit[q] = 0;
        }
        
        //total sales/profit for each item - loop through each dataPoint
        for(int j = 0; j < [itemSalesData count]; j++){
            NSMutableArray *dataPoint = [itemSalesData objectAtIndex:j];
            //add to every day total
            sold[0] += [[dataPoint objectAtIndex:2] intValue];
            profit[0] += [[dataPoint objectAtIndex:2] intValue] * ([[dataPoint objectAtIndex:3] doubleValue] - [[dataPoint objectAtIndex:4] doubleValue]);
            //add to appropriate day of week's total
            NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:[dataPoint objectAtIndex:5]];
            int dayOfWeek = [weekdayComponents weekday];
            sold[dayOfWeek] += [[dataPoint objectAtIndex:2] intValue];
            profit[dayOfWeek] += [[dataPoint objectAtIndex:2] intValue] * ([[dataPoint objectAtIndex:3] doubleValue] - [[dataPoint objectAtIndex:4] doubleValue]);
            
        }
        
        
        //prepare calculation entries - for the given item, 1 entry in each of the 8 day settings
        for(int q = 0; q < 8; q++){
            [[self.salesCalculationsByItem objectAtIndex:q] setObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:sold[q]/daysSold[q]],[NSNumber numberWithDouble:profit[q]/daysSold[q]], nil] forKey:[self.allKeys objectAtIndex:i]];
        
            //also add a pair of key-profit to the temp data structure that will be used for sorting/ranking (for each of the 8 day settings)
            
            NSArray *keyProfitPair = [NSArray arrayWithObjects:[self.allKeys objectAtIndex:i],[NSNumber numberWithDouble:profit[q]/daysSold[q]], nil];
            [[keyProfitPairsArray objectAtIndex:q] addObject:keyProfitPair];
        }
    }
    
  
    
    //sort the all of the keyProfitPairs
    for(int q = 0; q < 8; q++){
        [[keyProfitPairsArray objectAtIndex:q] sortUsingComparator:^(id obj1, id obj2){
            NSArray *kpp1 = (NSArray*)obj1;
            NSArray *kpp2 = (NSArray*)obj2;
            
            if([[kpp1 objectAtIndex:1] doubleValue] < [[kpp2 objectAtIndex:1] doubleValue])
                return (NSComparisonResult)NSOrderedDescending;
            else
                return (NSComparisonResult)NSOrderedAscending;
            
        }];
     
        //for each item, also add the newly found position to its calcPoint (at position [2])
        for(int k = 0; k < [self.allKeys count]; k++){
            NSArray *keyProfitPair = [(NSMutableArray*)[keyProfitPairsArray objectAtIndex: q] objectAtIndex:k];
            NSMutableArray *calcPoint = [[self.salesCalculationsByItem objectAtIndex: q] objectForKey:[keyProfitPair objectAtIndex:0]];
            [calcPoint addObject:[NSNumber numberWithDouble:k+1]];
        }
        
    }

    //set up the initial view controller
    if(self.currentKey == nil){
      
        ResultsByItemViewController *rbivc = [[UIStoryboard storyboardWithName:@"MainStoryboard"
                                                                    bundle: nil]instantiateViewControllerWithIdentifier:@"ResultsByItemViewController"];
        
        rbivc.keyNumber = 0;
        rbivc.key = [self.allKeys objectAtIndex:0];
        self.currentKey = [self.allKeys objectAtIndex:0];
        rbivc.itemSalesData = [self.salesDataByItem objectForKey:rbivc.key];
        rbivc.itemSalesCalculationData = self.salesCalculationsByItem;
        
    
    
    
        [self.myViewControllers setObject:rbivc forKey:rbivc.key];
    
        [self setViewControllers:[NSArray arrayWithObject:rbivc]
                   direction: UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
    }
    
    
}


//returns the number of days between the start date and the end date (if dayOfWeek = 0),
//otherwise returns the number of occurances of the given day of the week between the start 
//date and end date
+(int)numberOfXDays:(int)dayOfWeek withStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    //whole bunch of bullshit becuase I want to know the number of days between the two dates unaffected by time (i.e. 11 pm on 1/1 and 5 am on 1/2 should still be 1 day apart)
    NSDateComponents *startComponents = [gregorianCalendar components:NSMonthCalendarUnit |NSDayCalendarUnit | NSYearCalendarUnit fromDate:startDate];
    NSDateComponents *endComponents = [gregorianCalendar components:NSMonthCalendarUnit |NSDayCalendarUnit | NSYearCalendarUnit fromDate:endDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    startDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d",startComponents.year,startComponents.month, startComponents.day]];
    endDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d",endComponents.year,endComponents.month, endComponents.day]];
    
   

    
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    int totalDays = [components day] + 1; //plus 1 because we want total number of days, not the                                      different between the two 
    
    if(dayOfWeek == 0)
        return totalDays;
    
    int minDays = totalDays/7;
    int remainder = totalDays%7;
    
    if(dayOfWeek <= remainder)
        return minDays+1;
    else {
        return minDays;
    }
    
    
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
    
    ResultsByItemPageViewController *pvc = (ResultsByItemPageViewController*)pageViewController;
    ResultsByItemViewController *oldView = (ResultsByItemViewController*)viewController;
    
    int targetKeyNum = oldView.keyNumber - 1;
    if(targetKeyNum == -1)
        targetKeyNum = [pvc.allKeys count] - 1;
    
    ResultsByItemViewController *rbivc = [self.myViewControllers objectForKey:[self.allKeys objectAtIndex:targetKeyNum]];
    
    if(rbivc == nil){
        
        rbivc = [[UIStoryboard storyboardWithName:@"MainStoryboard"
                                           bundle: nil]instantiateViewControllerWithIdentifier:@"ResultsByItemViewController"];
        
        
        rbivc.keyNumber = targetKeyNum;
        rbivc.key = [self.allKeys objectAtIndex:rbivc.keyNumber];
        self.currentKey = [self.allKeys objectAtIndex:0];
        
        rbivc.itemSalesData = [self.salesDataByItem objectForKey:rbivc.key];
        rbivc.itemSalesCalculationData = self.salesCalculationsByItem;
        
        [self.myViewControllers setObject:rbivc forKey:rbivc.key];
        
    }
    
    rbivc.daySlider.value = oldView.daySlider.value;
    

    
    return rbivc;

}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
  
    
    ResultsByItemPageViewController *pvc = (ResultsByItemPageViewController*)pageViewController;
    ResultsByItemViewController *oldView = (ResultsByItemViewController*)viewController;
    
    int targetKeyNum = oldView.keyNumber + 1;
    if(targetKeyNum == [pvc.allKeys count])
        targetKeyNum = 0;
    
    ResultsByItemViewController *rbivc = [self.myViewControllers objectForKey:[self.allKeys objectAtIndex:targetKeyNum]];
    
    if(rbivc == nil){
        
        rbivc = [[UIStoryboard storyboardWithName:@"MainStoryboard"
                                           bundle: nil]instantiateViewControllerWithIdentifier:@"ResultsByItemViewController"];
        
        
        rbivc.keyNumber = targetKeyNum;
        rbivc.key = [self.allKeys objectAtIndex:rbivc.keyNumber];
        self.currentKey = [self.allKeys objectAtIndex:0];
        
        rbivc.itemSalesData = [self.salesDataByItem objectForKey:rbivc.key];
        rbivc.itemSalesCalculationData = self.salesCalculationsByItem;
        
        [self.myViewControllers setObject:rbivc forKey:rbivc.key];
   
        
    }
    
    rbivc.daySlider.value = oldView.daySlider.value;
    


    return rbivc;
    
    
    
    
  
    
  
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
        if ([touch.view isKindOfClass:[UISlider class]]) {
        // prevent recognizing touches on the slider
            return NO;
        }
        return YES;
        }


@end
