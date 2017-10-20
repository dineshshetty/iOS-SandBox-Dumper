//
//  ViewController.m
//  displayiOSSandboxDetails
//
//  Created by dns on 10/20/17.
//  Copyright © 2017 dns. All rights reserved.
//

#import "ViewController.h"
#import "LSApplicationProxy.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
    [self showInstalledApplications];
    
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

- (void)showInstalledApplications {
    
    // This function updates the UI Picker with the list of all the applications installed on the device (System + User)
    
    stringArray = [[NSMutableArray alloc] init];

    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    for (LSApplicationProxy *apps in [workspace performSelector:@selector(allApplications)])
    {
        NSString *localizedApplicationName = apps.localizedName;
        [stringArray addObject:localizedApplicationName];
        
    }
 //   NSLog(@"%@",stringArray);
    
    NSMutableArray *dataTest = [[NSMutableArray alloc] initWithArray:stringArray];
    _dataSourceArray =  dataTest;
    
    self.app_picker.dataSource = self;
    self.app_picker.delegate = self;
    

}


- (IBAction)view_sandbox_button:(id)sender {

    NSLog(@"Button Pressed");
    NSLog(@" You Selected: %@", _dataSourceArray[selectedRow]);
}
@end
