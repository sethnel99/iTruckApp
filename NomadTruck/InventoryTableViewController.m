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
@synthesize titleLabelView;
@synthesize inputBackgroundUIView;
@synthesize TableHeadingsBackgroundView;
@synthesize entrySalesData;
@synthesize entrySalesIndex;
@synthesize locationTextField;
@synthesize sender;
@synthesize DateInput;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [Truck deleteSalesEntryAtIndex:self.entrySalesIndex];
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
    [self.view endEditing:YES]; 
    if([self.sender isEqualToString:@"DateTable"]){
       [Truck updateSalesEntry:self.entrySalesData onEntryIndex:self.entrySalesIndex];
    }else{
        [Truck addSalesEntry:self.entrySalesData];
    }
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
    }else if([self.sender isEqualToString:@"AddButton"]){
        self.navigationItem.rightBarButtonItems = nil;
    }
    
    if([self.sender isEqualToString:@"DateTable"]){
    self.entrySalesData = [NSMutableArray arrayWithArray:[[Truck getSalesData] objectAtIndex:self.entrySalesIndex]];
    }else{
        //new data
        self.EntrySalesData = [[NSMutableArray alloc] init];
        [entrySalesData addObject:[NSDate date]];
        [entrySalesData addObject:@""];
        //for each menu item, add an entry which is a name, a before, and an after number
        
        NSMutableArray *inventory = [Truck getInventory];
        for(int i = 0; i < [inventory count]; i++){
            [entrySalesData addObject:[[NSArray alloc] initWithObjects:[[inventory objectAtIndex:i] name],[[inventory objectAtIndex:i] ParseID], [NSNumber numberWithInt:0], nil]];
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
   
    //set up date-time picker
    UIDatePicker *dp = [[UIDatePicker alloc] init];
    dp.datePickerMode = UIDatePickerModeDateAndTime;
    
    if([sender isEqualToString:@"Checkout"]){
        [dp setDate:[NSDate date]];
        [self.DateInput setText:[dateFormatter stringFromDate:dp.date]];
    }else if ([sender isEqualToString:@"DateTable"]){
        NSDate *tDate = (NSDate *)[self.entrySalesData objectAtIndex:0];
        NSLog(@"%@",tDate);
        [dp setDate:tDate];
        [self.DateInput setText:[dateFormatter stringFromDate:tDate]];
    }else if([sender isEqualToString:@"AddButton"]){
        [dp setDate:[NSDate date]];
    }
    
    locationTextField.text = [self.entrySalesData objectAtIndex:1];
    locationTextField.delegate = self;
    
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(doneWithDateInput)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    // Plug the keyboardDoneButtonView into the text field...
    DateInput.inputAccessoryView = keyboardDoneButtonView;

    
    
    DateInput.inputView = dp; 
    
    
    //add gradient to title label (really, to the uiview that houses it)
    [self.titleLabelView.layer insertSublayer:[Truck getTitleBarGradientWithFrame:self.titleLabelView.bounds] atIndex:0];
    
    //add gradients to other non-cell views
    [self.inputBackgroundUIView.layer insertSublayer:[Truck getCellGradientWithFrame:self.self.inputBackgroundUIView.bounds] atIndex:0];
    [self.TableHeadingsBackgroundView.layer insertSublayer:[Truck getCellGradientWithFrame:self.TableHeadingsBackgroundView.bounds] atIndex:0];
    //add borders to those views
    [self.inputBackgroundUIView.layer setBorderWidth:1.0];
    [self.inputBackgroundUIView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.TableHeadingsBackgroundView.layer setBorderWidth:1.0];
    [self.TableHeadingsBackgroundView.layer setBorderColor:[[UIColor blackColor] CGColor]];
  
    //add title bar logo
    self.navigationController.navigationBar.topItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo.png"]];
    

}

- (void) doneWithDateInput{
    [DateInput resignFirstResponder];
    UIDatePicker *tdp = (UIDatePicker*)DateInput.inputView;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    [DateInput setText:[dateFormatter stringFromDate:tdp.date]];
    [self.entrySalesData replaceObjectAtIndex:0 withObject:tdp.date];
}

- (void)viewDidUnload
{
    [self setLocationTextField:nil];
    [self setDateInput:nil];
    [self setTitleLabelView:nil];
    [self setInputBackgroundUIView:nil];
    [self setTableHeadingsBackgroundView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
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
    return [self.entrySalesData count] - 2;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.tag == 999){
        [self.entrySalesData replaceObjectAtIndex:1 withObject:textField.text];
    }else{
    
        int replIndex = textField.tag - 200 + 2;
        NSArray *dataPoint = [self.entrySalesData objectAtIndex:replIndex];
    
        NSArray *newDataPoint = [NSArray arrayWithObjects:[dataPoint objectAtIndex:0],[dataPoint objectAtIndex:1],[NSNumber numberWithInteger:[[textField text] integerValue]],nil];

  
        [self.entrySalesData replaceObjectAtIndex:replIndex withObject:newDataPoint];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	return YES;
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
    
    NSArray *salesPoint = [self.entrySalesData objectAtIndex:(indexPath.row+2)];
    
    nameLabel.text = [salesPoint objectAtIndex:0];
    soldInput.text = [NSString stringWithFormat:@"%@",[salesPoint objectAtIndex:2]];
    
    //apply gradient 
    [cell.layer insertSublayer:[Truck getCellGradientWithFrame:cell.bounds] atIndex:0];
    
    

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
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
