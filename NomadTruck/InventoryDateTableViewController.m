//
//  InventoryDateTableViewController.m
//  NomadTruck
//
//  Created by Farley User on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InventoryDateTableViewController.h"
#import "Truck.h"
#import "MenuFoodItem.h"
#import "InventoryTableViewController.h"

@interface InventoryDateTableViewController ()

@end

@implementation InventoryDateTableViewController
@synthesize titleLabelView;
@synthesize salesData;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    InventoryTableViewController *itvc = (InventoryTableViewController *)[segue destinationViewController];
    
    if([segue.identifier isEqualToString:@"DateTableToSalesRecordSegue"]){
        itvc.entrySalesIndex = [[self tableView] indexPathForCell:sender].row;
        itvc.sender = @"DateTable";
    }else if([segue.identifier isEqualToString:@"AddSalesRecordSegue"]){
        itvc.entrySalesIndex = -1;
        itvc.sender = @"AddButton";
    }

}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.salesData = [Truck getSalesData];
    
    //add gradient to title label (really, to the uiview that houses it)
    [self.titleLabelView.layer insertSublayer:[Truck getTitleBarGradientWithFrame:self.titleLabelView.bounds] atIndex:0];
    
    
    
    
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

- (void)viewWillAppear:(BOOL)animated{
    salesData = [Truck getSalesData];
    [self.tableView reloadData];
    [super viewWillAppear:animated];
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
    return [[Truck sharedTruck].salesData count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
  
    NSMutableArray *singleDataSet = [salesData objectAtIndex:indexPath.row];
    NSDate *tempDate = [singleDataSet objectAtIndex:0];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:tempDate];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    int hour = [components hour];
    NSString *ampm = @"am";
    if(hour > 12){
        hour -= 12;
        ampm = @"pm";
    }
    ((UILabel*)[cell viewWithTag:100]).text = [NSString stringWithFormat:@"%@ %dth, %d",
                           [[df monthSymbols] objectAtIndex:([components month] - 1)],
                           [components day],[components year]];
    ((UILabel*)[cell viewWithTag:101]).text = [NSString stringWithFormat:@"%02d:%02d %@",
                                               [components hour],[components minute],ampm];
    
    ((UILabel*)[cell viewWithTag:102]).text = [singleDataSet objectAtIndex:1];
    
    //apply gradient
    [cell.layer insertSublayer:[Truck getCellGradientWithFrame:cell.bounds] atIndex:0];
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
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
