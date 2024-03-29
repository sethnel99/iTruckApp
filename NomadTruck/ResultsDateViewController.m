//
//  ResultsDateViewController.m
//  NomadTruck
//
//  Created by Farley User on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResultsDateViewController.h"
#import "Truck.h"
#import "ResultsViewController.h"

@interface ResultsDateViewController ()

@end

@implementation ResultsDateViewController
@synthesize titleLabelView;
@synthesize salesByDay;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    ResultsViewController *itvc = (ResultsViewController *)[segue destinationViewController];
    itvc.daySalesIndex = [[self tableView] indexPathForCell:sender].row;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.salesByDay = [Truck getSalesDataByDay];
    [self.tableView reloadData];

}

- (void)viewDidLoad
{

    [super viewDidLoad];
    //add gradient to title label (really, to the uiview that houses it)
    [self.titleLabelView.layer insertSublayer:[Truck getTitleBarGradientWithFrame:self.titleLabelView.bounds] atIndex:0];
    //add title bar logo
    //self.navigationController.navigationBar.topItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo.png"]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setTitleLabelView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.salesByDay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResultsDateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *unitsSoldLabel = (UILabel *)[cell viewWithTag:103];
    UILabel *revenueLabel = (UILabel *)[cell viewWithTag:104];
    
    int numSold = 0;
    double revenue = 0;
    
    NSMutableArray *daySalesData = [self.salesByDay objectAtIndex:indexPath.row];
    for(int i = 0; i < [daySalesData count]; i++){
        NSMutableArray *singleSalesEntry = [daySalesData objectAtIndex:i];
        for(int j = 2; j < [singleSalesEntry count]; j++){
            NSArray *salesDataPoint = [singleSalesEntry objectAtIndex:j];
            numSold += [[salesDataPoint objectAtIndex:2] intValue];
            revenue += [[salesDataPoint objectAtIndex:2] intValue] * [[salesDataPoint objectAtIndex:3] doubleValue];   
        }
    }
    
    unitsSoldLabel.text = [NSString stringWithFormat:@"%d", numSold];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    revenueLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:revenue]];
    
    
    NSMutableArray *firstEntry = [daySalesData objectAtIndex:0];
    NSDate *tempDate = (NSDate*)[firstEntry objectAtIndex:0];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:tempDate];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    dateLabel.text = [NSString stringWithFormat:@"%@ %d%@, %d",
                           [[df monthSymbols] objectAtIndex:([components month] - 1)],
                      [components day],[Truck getAffixForDay:[components day]],[components year]];
    
    //apply gradient 
    [cell.layer insertSublayer:[Truck getCellGradientWithFrame:cell.bounds] atIndex:0];
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
