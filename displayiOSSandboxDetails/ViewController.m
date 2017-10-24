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
    //
    
    stringArrayAppName = [[NSMutableArray alloc] init];
    stringArrayAppid = [[NSMutableArray alloc] init];


    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    for (LSApplicationProxy *apps in [workspace performSelector:@selector(allApplications)])
    {
        NSString *localizedApplicationName = apps.localizedName;
        //Use NSString *localizedApplicationName = apps.applicationIdentifier to use application identifiers in Picker
        [stringArrayAppName addObject:localizedApplicationName];
        [stringArrayAppid addObject:apps.applicationIdentifier];
    }
 //   NSLog(@"%@",stringArray);
    
    NSMutableArray *appNamesData = [[NSMutableArray alloc] initWithArray:stringArrayAppName];
    _dataSourceArray =  appNamesData;
    
    NSMutableArray *appIdData = [[NSMutableArray alloc] initWithArray:stringArrayAppid];
    _dataSourceAppIdArray =  appIdData;
    
    self.app_picker.dataSource = self;
    self.app_picker.delegate = self;
    

}

- (NSMutableDictionary*)getApplicationSandboxDetails {
    NSDictionary *appBundleInformation = nil;
    NSMutableDictionary *all_apps = [NSMutableDictionary new];

    
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    
    
    for (FBApplicationInfo *apps in [workspace performSelector:@selector(allApplications)])
    {
        NSString *appName = ((LSApplicationProxy*)apps).itemName;
        if (!appName)
        {
            appName = ((LSApplicationProxy*)apps).localizedName;
        }
        

        NSString *minimumSupportedOS = ((LSApplicationProxy*)apps).minimumSystemVersion;
        if (!minimumSupportedOS)
        {
            minimumSupportedOS = @"";
        }
        
        NSString *appTeamID = ((LSApplicationProxy*)apps).teamID;
        if (!appTeamID)
        {
            appTeamID = @"";
        }
        
        //Using Absolute to fix Invalid type in JSON write (NSURL) error - http://www.itgo.me/a/x4350498357866144658/json-string-from-nsdictionary-having-file-path
        
        NSString *absoluteBundleIdentifier = @"";
        if (apps.bundleIdentifier)
        {
            absoluteBundleIdentifier = apps.bundleIdentifier ;
            
        }
        
        NSString *absoluteBundleURL = @"";
        if (apps.bundleURL)
        {
            absoluteBundleURL = [apps.bundleURL absoluteString];

        }
        
        NSString *absoluteBundleContainerURL = @"";
        if (apps.bundleContainerURL)
        {
            absoluteBundleContainerURL = [apps.bundleContainerURL absoluteString];
        }
        
        NSString *absoluteDataContainerURL = @"";
        if (apps.dataContainerURL)
        {
            absoluteDataContainerURL = [apps.dataContainerURL absoluteString];
        }
        
 
        appBundleInformation = @{
                       @"DisplayName": appName,
                       @"MinSdkVersion": minimumSupportedOS,
                       @"TeamID" : appTeamID,
                       @"BundleIdentifier": absoluteBundleIdentifier,
                       @"BundleURL":absoluteBundleURL,
                       @"BundleContainer":absoluteBundleContainerURL,
                       @"DataContainer": absoluteDataContainerURL,
                       };
    
        all_apps[apps.bundleIdentifier] = appBundleInformation;

    }
    
    return all_apps;
}

- (void)sandBoxDataDisplay:(NSString *)text {
    // NSLog(@"In debugPrint = %@", text);
    
    [_textview_sandbox_data_display
     setText:text];
}



- (IBAction)view_sandbox_button:(id)sender {

    NSLog(@" You Selected the application %@ with appId %@ ", _dataSourceArray[selectedRow], _dataSourceAppIdArray[selectedRow]);
    
    NSMutableDictionary *all_apps =[self getApplicationSandboxDetails];
    NSDictionary* dictSelectedAppBundleInfo= all_apps[_dataSourceAppIdArray[selectedRow]];
    NSLog(@"%@",dictSelectedAppBundleInfo);
    [self sandBoxDataDisplay:[NSString stringWithFormat:@"Details:%@",dictSelectedAppBundleInfo]];
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}
@end
