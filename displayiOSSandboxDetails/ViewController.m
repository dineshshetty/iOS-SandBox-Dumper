//
//  ViewController.m
//  displayiOSSandboxDetails
//
//  Created by dns on 10/20/17.
//  Copyright © 2017 dns. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataSourceArray = @[@"PickerValueRowOne", @"PickerValueRowTwo", @"PickerValueRowThree", @"PickerValueRowFour"];
    self.app_picker.dataSource = self;
    self.app_picker.delegate = self;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Handles the number of component (columns) of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
// Handles the number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataSourceArray.count;
}
// Function returns the data for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // NSLog(_dataSourceArray[row]);
    return _dataSourceArray[row];
}

// Function handles the selection of component in the picker window
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    // NSLog(_dataSourceArray[row]);
    selectedRow = row;
    //   selectedEntry = [allEntries objectAtIndex:row];
    
}



- (IBAction)view_sandbox_button:(id)sender {

    NSLog(@"Button Pressed");
    NSLog(@" You Selected: %@", _dataSourceArray[selectedRow]);
}
@end
