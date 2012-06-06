//
//  ResultsByItemViewController.m
//  NomadTruck
//
//  Created by Farley User on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResultsByItemViewController.h"
#import "ResultsByItemPageViewController.h"
#import "Truck.h"

@interface ResultsByItemViewController ()

@end

@implementation ResultsByItemViewController
@synthesize keyNumber;
@synthesize key;
@synthesize itemSalesData;
@synthesize itemSalesCalculationData;
@synthesize grossMargin;
@synthesize daySlider;
@synthesize daySliderLabel;
@synthesize soldPerDayLabel;
@synthesize profitPerDayLabel;
@synthesize profitRankLabel;
@synthesize grossMarginLabel;
@synthesize bestLocationLabel;
@synthesize titleLabelView;
@synthesize itemNameLabel;
@synthesize startingSliderValue;

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
      self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    
    //add gradient to title label (really, to the uiview that houses it)
    [self.titleLabelView.layer insertSublayer:[Truck getTitleBarGradientWithFrame:self.titleLabelView.bounds] atIndex:0];
}

- (void)viewDidAppear:(BOOL)animated{
    [self moreCalculations];
    
    if(self.startingSliderValue >= 0){
        self.daySlider.value = self.startingSliderValue;
        self.startingSliderValue = -1;
        [self sliderChanged:nil];
    }
    
    
    [self setDataForSliderPosition:lroundf(self.daySlider.value)];
}

-(void)viewWillAppear:(BOOL)animated{
    self.itemNameLabel.text = [(NSMutableArray*)[self.itemSalesData objectAtIndex:0] objectAtIndex:0];
}

- (void)moreCalculations{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    //prep location ranking - sort this day's dataPoints by Location
    //loop through all sales data, sort into dictionary by location
    NSMutableDictionary *dataPointsByLocation = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < [self.itemSalesData count]; i++){
        NSMutableArray *dataPoint = [self.itemSalesData objectAtIndex:i];
        NSMutableArray *array = [dataPointsByLocation objectForKey:[dataPoint objectAtIndex:6]]; //keyed by datapoints's location
        if(array == nil){
            array = [NSMutableArray arrayWithObject:dataPoint];
            [dataPointsByLocation setObject:array forKey:[dataPoint objectAtIndex:6]];
        }else{
            [array addObject:dataPoint]; 
        }
    }
    
    
    //gross margin
    NSMutableArray *randomDataPoint = [self.itemSalesData objectAtIndex:0];
    //(revenue-cost)/revenue
    self.grossMargin = ([[randomDataPoint objectAtIndex:3] doubleValue]-[[randomDataPoint objectAtIndex:4] doubleValue])/[[randomDataPoint objectAtIndex:3] doubleValue] * 100;
    
    
    //location ranking (pretty much the same as finding profit per day (in the page view controller), but now it's profit/day at a specific location!
    
    NSArray *allLocationKeys = [dataPointsByLocation allKeys];
    NSMutableArray *keyProfitPairsArray = [[NSMutableArray alloc] init];
    for(int q = 0; q < 8; q++){
        [keyProfitPairsArray addObject:[[NSMutableOrderedSet alloc] init]];
    }
        
    //sum up each sales location
    for(int i = 0; i < [allLocationKeys count]; i++){
        //grab the sales data for this specific location
        NSMutableArray *locSalesData = [dataPointsByLocation objectForKey:[allLocationKeys objectAtIndex:i]];
        
        //first date this item was sold and last date this time was sold
        NSMutableArray *firstEntry = [locSalesData objectAtIndex:0];
        NSMutableArray *lastEntry = [locSalesData lastObject];
        
        double daysSold[8];
        double profit[8];
        for(int q = 0; q < 8; q++){
            daysSold[q] = [ResultsByItemPageViewController numberOfXDays:q withStartDate:[firstEntry objectAtIndex:5] withEndDate:[lastEntry objectAtIndex:5]];
            if(daysSold[q] == 0) //quick error fix - if daysSold[q] = 0, then this item was never sold on this day of the week. This means that the sales/profits will be 0 anyway. So change it to 1, so 0/1 = 0 instead of 0/0 = nan.
                daysSold[q] = 1;
            profit[q] = 0;
        }
        
        //total profit at this location
        for(int j = 0; j < [locSalesData count]; j++){
            NSMutableArray *dataPoint = [locSalesData objectAtIndex:j];
            //add to every day total
            profit[0] += [[dataPoint objectAtIndex:2] intValue] * ([[dataPoint objectAtIndex:3] doubleValue] - [[dataPoint objectAtIndex:4] doubleValue]);
            //add to appropriate day of week's total
            NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:[dataPoint objectAtIndex:5]];
            int dayOfWeek = [weekdayComponents weekday];
            profit[dayOfWeek] += [[dataPoint objectAtIndex:2] intValue] * ([[dataPoint objectAtIndex:3] doubleValue] - [[dataPoint objectAtIndex:4] doubleValue]);
        }
        
        //add a pair of key-profit to the temp data structure that will be used for sorting/ranking (for each of the 8 day settings)
        for(int q = 0; q < 8; q++){
            NSArray *keyProfitPair = [NSArray arrayWithObjects:[allLocationKeys objectAtIndex:i],[NSNumber numberWithDouble:profit[q]/daysSold[q]], nil];
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
    }
        
    for(int q = 0; q < 8; q++){
       //add the best location to each calcPoint for the 8 time settings 
        NSMutableDictionary *calcData = [self.itemSalesCalculationData objectAtIndex:q];
        NSMutableArray *calcPoint = [calcData objectForKey:self.key];
        [calcPoint addObject:[(NSMutableArray*)[(NSMutableArray*)[keyProfitPairsArray objectAtIndex:q] objectAtIndex:0] objectAtIndex:0]];
        
        //in the future - save this ordered list for a rankings page
        
    }
    
    

}

- (void)viewDidUnload
{
    [self setDaySlider:nil];
    [self setDaySliderLabel:nil];
    [self setSoldPerDayLabel:nil];
    [self setProfitPerDayLabel:nil];
    [self setProfitRankLabel:nil];
    [self setGrossMarginLabel:nil];
    [self setBestLocationLabel:nil];
    [self setTitleLabelView:nil];
    [self setItemNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) setDataForSliderPosition:(int)sliderValue{
    //the calc point, the point for the correct slider value, whose key is the object's parseID (which can be found by looking at any item in itemSalesData's index 1)
    NSMutableArray *calcPoint = [(NSMutableDictionary*)[self.itemSalesCalculationData objectAtIndex:sliderValue] objectForKey:[(NSMutableArray*)[self.itemSalesData objectAtIndex:0] objectAtIndex:1]];
    
    self.soldPerDayLabel.text = [NSString stringWithFormat:@"%d",[[calcPoint objectAtIndex:0] intValue]];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    self.profitPerDayLabel.text = [numberFormatter stringFromNumber:[calcPoint objectAtIndex:1]];
    self.profitRankLabel.text = [NSString stringWithFormat:@"%d%@",[[calcPoint objectAtIndex:2] intValue],[Truck getAffixForNumber:[[calcPoint objectAtIndex:2] intValue]]];
    
    self.grossMarginLabel.text = [NSString stringWithFormat:@"%.1f%%",self.grossMargin];
    self.bestLocationLabel.text = [calcPoint objectAtIndex:3];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)sliderRelease:(id)sender 
{
    int sliderValue;
    sliderValue = lroundf(self.daySlider.value);
    [daySlider setValue:sliderValue animated:YES];
    
}

- (IBAction)sliderChanged:(id)sender 
{
    int sliderValue;
    sliderValue = lroundf(self.daySlider.value);
    [self setDataForSliderPosition:sliderValue];
    switch(sliderValue){
        case 0:
            daySliderLabel.text = @"Every Day";
            break;
        case 1:
            daySliderLabel.text = @"Sunday";
            break;
        case 2:
            daySliderLabel.text = @"Monday";
            break;
        case 3:
            daySliderLabel.text = @"Tuesday";
            break;
        case 4:
            daySliderLabel.text = @"Wednesday";
            break;
        case 5:
            daySliderLabel.text = @"Thursday";
            break;
        case 6:
            daySliderLabel.text = @"Friday";
            break;
        case 7:
            daySliderLabel.text = @"Saturday";
            break;
            
            
    }
    
}

@end
