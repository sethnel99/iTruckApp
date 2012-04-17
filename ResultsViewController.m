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
@synthesize stopPicker;
@synthesize mostSoldLabel;
@synthesize mostProfitableLabel;
@synthesize salesPerformanceLabel;
@synthesize timeLabel;
@synthesize locationLabel;
@synthesize daySalesIndex;
@synthesize daySales;


- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    CALayer *mostSoldLayer = self.mostSoldLabel.layer;
    mostSoldLayer.backgroundColor = [UIColor redColor].CGColor;
    mostSoldLayer.cornerRadius = 10;
    self.mostSoldLabel.textColor = [UIColor greenColor];
    
    CALayer *mostProfitLayer = self.mostProfitableLabel.layer;
    mostProfitLayer.backgroundColor = [UIColor redColor].CGColor;
    mostProfitLayer.cornerRadius = 10;
    self.mostProfitableLabel.textColor = [UIColor greenColor];
    
    CALayer *salesPerformanceLayer = self.salesPerformanceLabel.layer;
    salesPerformanceLayer.backgroundColor = [UIColor redColor].CGColor;
    salesPerformanceLayer.cornerRadius = 10;
    self.salesPerformanceLabel.textColor = [UIColor greenColor];
    
    [stopPicker removeAllSegments];
    [stopPicker insertSegmentWithTitle:@"Day" atIndex:0 animated:YES];
    for(int i = 0; i < [self.daySales count]; i++){
       [stopPicker insertSegmentWithTitle:[NSString stringWithFormat:@"Stop %d",(i+1)] atIndex:(i+1) animated:YES]; 
    }
    
    [stopPicker setSelectedSegmentIndex:0];
    
   
    [self setDayLabels];
    

                                
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)setDayLabels{
    timeLabel.text = @"N/A";
    locationLabel.text = @"N/A";
    
    NSMutableArray *aggregateSales = [self.daySales objectAtIndex:0];
    
    for(int i = 1; i < [self.daySales count]; i++){
        NSMutableArray *stopSales = [self.daySales objectAtIndex:i];
        for(int j = 2; j < [stopSales count]; j++){
            NSArray *dataPoint = [stopSales objectAtIndex:j];
            NSArray *aggPoint = [aggregateSales objectAtIndex:j];
            NSNumber *addition = [NSNumber numberWithInt:[(NSNumber *)[aggPoint objectAtIndex:2] intValue] +[(NSNumber *)[dataPoint objectAtIndex:2] intValue]];
            
            [aggregateSales replaceObjectAtIndex:j withObject:[NSArray arrayWithObjects:[aggPoint objectAtIndex:0],[aggPoint objectAtIndex:1],addition,nil]];

        }
    }
    
    int maxIndex = 0;
    int maxSold = 0; 
    int maxProfitIndex = 0;
    double maxProfit = 0;
    
    for(int i = 2; i < [aggregateSales count]; i++){
        NSArray *aggPoint = [aggregateSales objectAtIndex:i];
        int sold = [[aggPoint objectAtIndex:2] intValue];
        int profit = sold * [Truck priceForInventoryItem:(i-2)];
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
    
    
    NSArray *mostSoldPoint = [aggregateSales objectAtIndex:maxIndex];
    NSArray *mostProfitPoint = [aggregateSales objectAtIndex:maxProfitIndex];
    mostSoldLabel.text = [NSString stringWithFormat:@"%@ \n (%d)",[mostSoldPoint objectAtIndex:0],maxSold];
    mostProfitableLabel.text = [NSString stringWithFormat:@"%@ \n (%@)",[mostProfitPoint objectAtIndex:0],[numberFormatter stringFromNumber:[NSNumber numberWithDouble:maxProfit]]];
    
    
    int mslSize = mostSoldLabel.frame.size.width;
    int mplSize = mostProfitableLabel.frame.size.width;
    
    [mostSoldLabel sizeToFit];
    [mostProfitableLabel sizeToFit];
    
    int mslSize2 = mostSoldLabel.frame.size.width;
    int mplSize2 = mostProfitableLabel.frame.size.width;
    
    [mostSoldLabel setFrame:CGRectMake(mostSoldLabel.frame.origin.x + (mslSize-mslSize2)/2, mostSoldLabel.frame.origin.y, mostSoldLabel.frame.size.width, mostSoldLabel.frame.size.height)];
     [mostProfitableLabel setFrame:CGRectMake(mostProfitableLabel.frame.origin.x + (mplSize-mplSize2)/2, mostProfitableLabel.frame.origin.y, mostProfitableLabel.frame.size.width, mostProfitableLabel.frame.size.height)];
    
    
  
}

-(void)setStopLabels:(int)index{
    
}

- (void)viewDidUnload
{
    [self setStopPicker:nil];
    [self setMostSoldLabel:nil];
    [self setMostProfitableLabel:nil];
    [self setSalesPerformanceLabel:nil];
    [self setTimeLabel:nil];
    [self setLocationLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
