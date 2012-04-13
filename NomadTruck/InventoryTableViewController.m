//
//  InventoryTableViewController.m
//  NomadTruck
//
//  Created by Farley User on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InventoryTableViewController.h"
#import "Truck.h"
#import "MenuFoodItem.h"
#import "CustomInventoryInputCell.h"

@interface InventoryTableViewController ()

@end

@implementation InventoryTableViewController
@synthesize daySalesData;
@synthesize daySalesIndex;
@synthesize locationTextField;
@synthesize sender;
@synthesize DateInput;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [Truck deleteSalesDayAtIndex:self.daySalesIndex];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)topRightButtonPressed:(id)sender {
    if([self.sender isEqualToString:@"DateTable"]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Delete Data"
                              message: @"Are you sure you wish to delete this sales record?"
                              delegate: self
                              cancelButtonTitle:@"No"
                              otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}

- (IBAction)saveInventoryChanges:(UIButton *)sender {
    [self.daySalesData replaceObjectAtIndex:1 withObject:self.locationTextField.text];
    [Truck updateSalesDay:self.daySalesData onDayIndex:self.daySalesIndex];
    [self.navigationController popViewControllerAnimated:YES];
    
    
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
    if ([self.sender isEqualToString:@"Checkout"]) {
        self.navigationItem.rightBarButtonItem.title = @"Skip";
    }
    
    
    //set up date-time picker
    UIDatePicker *dp = [[UIDatePicker alloc] init];
    dp.datePickerMode = UIDatePickerModeDateAndTime;
    [dp setDate:[NSDate date]];
    
    UIButton *b = [[UIButton alloc] init];
    b.titleLabel.text = @"Done";
    [b addTarget:self 
               action:@selector(doneWithDateInput)
     forControlEvents:UIControlEventTouchDown];
    
    
    DateInput.inputView = dp;
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) doneWithDateInput{
    [DateInput resignFirstResponder];
}

- (void)viewDidUnload
{
    [self setLocationTextField:nil];
    [self setDateInput:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    self.daySalesData = [NSMutableArray arrayWithArray:[[Truck getSalesData] objectAtIndex:self.daySalesIndex]];
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
    return [self.daySalesData count] - 2;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    UITableViewCell *superCell = (UITableViewCell *)[[textField superview] superview];
    int replIndex = textField.tag - 200 + 2;
    [self.daySalesData replaceObjectAtIndex:replIndex withObject:[NSArray arrayWithObjects:[(UILabel *)[superCell viewWithTag:100] text], textField.text.integerValue,nil]];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InventoryCell";
    CustomInventoryInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CustomInventoryInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    UITextField *soldInput = (UITextField *)[cell viewWithTag:102];

    soldInput.delegate = self;
    soldInput.tag = 200+indexPath.row;
    cell.textTag = 200+indexPath.row;
    
    NSArray *salesPoint = [self.daySalesData objectAtIndex:(indexPath.row+2)];
    
    nameLabel.text = [salesPoint objectAtIndex:0];
    soldInput.text = [NSString stringWithFormat:@"%@",[salesPoint objectAtIndex:1]];
    
    
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
