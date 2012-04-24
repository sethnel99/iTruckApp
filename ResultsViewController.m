//
//  ResultsViewController.m
//  NomadTruck
//
//  Created by Farley User on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResultsViewController.h"
#import "Truck.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController
@synthesize titleLabelView;
@synthesize stopPicker;
@synthesize mostSoldLabel;
@synthesize mostProfitableLabel;
@synthesize salesPerformanceLabel;
@synthesize timeLabel;
@synthesize locationLabel;
@synthesize dateLabel;
@synthesize daySalesIndex;
@synthesize daySales;
@synthesize aggregateSales;
@synthesize salesPerformancesByStop;
@synthesize salesPerformanceForDay;
@synthesize salesByDay;

- (IBAction)segmentedControlClicked:(UISegmentedControl*)sender {
    int index = [sender selectedSegmentIndex];
    if(index == 0)
        [self setDayLabels];
    else {
        [self setStopLabels:index - 1];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
   self.stopPicker.tintColor = [Truck getTealGreenTint];
    self.stopPicker.segmentedControlStyle = UISegmentedControlStyleBar;
    
 
    //add gradient to title label (really, to the uiview that houses it)
    [self.titleLabelView.layer insertSublayer:[Truck getTitleBarGradientWithFrame:self.titleLabelView.bounds] atIndex:0];
    
    //add title bar logo
    self.navigationController.navigationBar.topItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo.png"]];
                                
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    self.daySales = [self.salesByDay objectAtIndex:self.daySalesIndex];
    [stopPicker removeAllSegments];
    [stopPicker insertSegmentWithTitle:@"Day" atIndex:0 animated:YES];
    for(int i = 0; i < [self.daySales count]; i++){
        [stopPicker insertSegmentWithTitle:[NSString stringWithFormat:@"Stop %d",(i+1)] atIndex:(i+1) animated:YES]; 
    }
    
    [stopPicker setSelectedSegmentIndex:0];
    
    
    self.salesPerformancesByStop = [[NSMutableArray alloc] init]; 
    
    self.aggregateSales = [NSMutableArray arrayWithArray:[self.daySales objectAtIndex:0]];
    //add up sales for the first stop stop
     double totalMoneyForDay = 0;
     double totalMoneyForStop = 0;
    for(int j = 2; j < [aggregateSales count]; j++){
        NSArray *dataPoint = [aggregateSales objectAtIndex:j];
        int itemsSold = [[dataPoint objectAtIndex:2] intValue];
        double itemProfit = itemsSold * [Truck priceForInventoryItem:(j-2)];
        totalMoneyForStop += itemProfit;
        totalMoneyForDay += itemProfit;
    }
    int salesPerformanceForStop = totalMoneyForStop / ([Truck getTotalMoney]/[[Truck getSalesData] count]) * 100;
    
    [self.salesPerformancesByStop addObject:[NSNumber numberWithInt:salesPerformanceForStop]];
    //end add up sales for the first stop
    
    //aggregate sales. Also continue to add sales totals for the rest of the stops
   
    for(int i = 1; i < [self.daySales count]; i++){
        NSMutableArray *stopSales = [self.daySales objectAtIndex:i];
        double totalMoneyForStop = 0;
        
        for(int j = 2; j < [stopSales count]; j++){
            NSArray *dataPoint = [stopSales objectAtIndex:j];
            NSArray *aggPoint = [self.aggregateSales objectAtIndex:j];
            
            int itemsSold = [[dataPoint objectAtIndex:2] intValue];
            double itemProfit = itemsSold * [Truck priceForInventoryItem:(j-2)];
            totalMoneyForStop += itemProfit;
            totalMoneyForDay += itemProfit;
            
            NSNumber *addition = [NSNumber numberWithInt:[(NSNumber *)[aggPoint objectAtIndex:2] intValue] + itemsSold];
            
            [self.aggregateSales replaceObjectAtIndex:j withObject:[NSArray arrayWithObjects:[aggPoint objectAtIndex:0],[aggPoint objectAtIndex:1],addition,nil]];
            
            
            
        }
        int salesPerformanceForStop = totalMoneyForStop / ([Truck getTotalMoney]/[[Truck getSalesData] count]) * 100;
        [self.salesPerformancesByStop addObject:[NSNumber numberWithInt:salesPerformanceForStop]];
        
    }
    self.salesPerformanceForDay = totalMoneyForDay / ([Truck getTotalMoney]/[[Truck getSalesDataByDay] count]) * 100;
    
    [self setDayLabels];
}

-(void)setDayLabels{
    timeLabel.text = @"N/A";
    locationLabel.text = @"N/A";
    
    NSDate *tempDate = [((NSMutableArray *)[self.daySales objectAtIndex:0]) objectAtIndex:0];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:tempDate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %dth, %d",
                           [[df monthSymbols] objectAtIndex:([components month] - 1)],
                           [components day],[components year]];
    
    int maxIndex = 0;
    int maxSold = 0; 
    int maxProfitIndex = 0;
    double maxProfit = 0;
    
    for(int i = 2; i < [self.aggregateSales count]; i++){
        NSArray *aggPoint = [self.aggregateSales objectAtIndex:i];
        int sold = [[aggPoint objectAtIndex:2] intValue];
        double profit = sold * [Truck priceForInventoryItem:(i-2)];
        if(sold > maxSold){
            maxSold = sold;
            maxIndex = i;
        }
        if(profit > maxProfit){
            maxProfit = profit;
            maxProfitIndex = i;
        }
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    
    NSArray *mostSoldPoint = [self.aggregateSales objectAtIndex:maxIndex];
    NSArray *mostProfitPoint = [self.aggregateSales objectAtIndex:maxProfitIndex];
    self.mostSoldLabel.text = [NSString stringWithFormat:@"%@ (%d)",[mostSoldPoint objectAtIndex:0],maxSold];
    self.mostProfitableLabel.text = [NSString stringWithFormat:@"%@ (%@)",[mostProfitPoint objectAtIndex:0],[numberFormatter stringFromNumber:[NSNumber numberWithDouble:maxProfit]]];
        
    self.salesPerformanceLabel.text = [NSString stringWithFormat:@"%d%%",
                                  self.salesPerformanceForDay];
    
    
    
  
}

-(void)setStopLabels:(int)index{
    NSMutableArray *stopSales = [self.daySales objectAtIndex:index];
    
    NSDate *tempDate = [stopSales objectAtIndex:0];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:tempDate];
    int hour = [components hour];
    NSString *ampm = @"am";
    if(hour > 12){
        hour -= 12;
        ampm = @"pm";
    }
                           
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d %@",hour,[components minute],ampm];

    self.locationLabel.text = [stopSales objectAtIndex:1];
    
    int maxIndex = 0;
    int maxSold = 0; 
    int maxProfitIndex = 0;
    double maxProfit = 0;
    
    for(int i = 2; i < [stopSales count]; i++){
        NSArray *salesPoint = [stopSales objectAtIndex:i];
        int sold = [[salesPoint objectAtIndex:2] intValue];
        double profit = sold * [Truck priceForInventoryItem:(i-2)];
        if(sold > maxSold){
            maxSold = sold;
            maxIndex = i;
        }
        if(profit > maxProfit){
            maxProfit = profit;
            maxProfitIndex = i;
        }
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    
    NSArray *mostSoldPoint = [stopSales objectAtIndex:maxIndex];
    NSArray *mostProfitPoint = [stopSales objectAtIndex:maxProfitIndex];
    self.mostSoldLabel.text = [NSString stringWithFormat:@"%@ (%d)",[mostSoldPoint objectAtIndex:0],maxSold];
    self.mostProfitableLabel.text = [NSString stringWithFormat:@"%@ (%@)",[mostProfitPoint objectAtIndex:0],[numberFormatter stringFromNumber:[NSNumber numberWithDouble:maxProfit]]];
  
    
    self.salesPerformanceLabel.text = [NSString stringWithFormat:@"%d%%",
                                  [[self.salesPerformancesByStop objectAtIndex:index] intValue]];
    
    
}


- (void)viewDidUnload
{
    [self setStopPicker:nil];
    [self setMostSoldLabel:nil];
    [self setMostProfitableLabel:nil];
    [self setSalesPerformanceLabel:nil];
    [self setTimeLabel:nil];
    [self setLocationLabel:nil];
    [self setTitleLabelView:nil];
    [self setDateLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
