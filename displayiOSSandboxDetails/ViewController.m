//
//  ViewController.m
//  displayiOSSandboxDetails
//
//  Created by dns on 10/20/17.
//  Copyright © 2017 dns. All rights reserved.
//

#import "ViewController.h"
#import "InfoTableViewCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *selectedAppBundleInfo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showInstalledApplications];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[InfoTableViewCell nib] forCellReuseIdentifier:[InfoTableViewCell identifier]];
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
        NSString *applicationIdentifier = apps.applicationIdentifier;
        if (localizedApplicationName && applicationIdentifier)
        {
            [stringArrayAppName addObject:localizedApplicationName];
            [stringArrayAppid addObject:apps.applicationIdentifier];
        }
    }
    
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
        
        @try{
            appBundleInformation = @{
                                     @"DisplayName": appName,
                                     @"MinSdkVersion": minimumSupportedOS,
                                     @"TeamID" : appTeamID,
                                     @"BundleIdentifier": absoluteBundleIdentifier,
                                     @"BundleURL":absoluteBundleURL,
                                     @"BundleContainer":absoluteBundleContainerURL,
                                     @"DataContainer": absoluteDataContainerURL,
                                     };
        }@catch (NSException* e){
            NSLog(@"Exception = %@", e);
        }@finally {
            all_apps[apps.bundleIdentifier] = appBundleInformation;
        }
        
    }
    
    return all_apps;
}

- (IBAction)view_sandbox_button:(id)sender {
    
    NSLog(@" You Selected the application %@ with appId %@ ", _dataSourceArray[selectedRow], _dataSourceAppIdArray[selectedRow]);
    
    NSMutableDictionary *all_apps =[self getApplicationSandboxDetails];
    NSDictionary *dictSelectedAppBundleInfo = all_apps[_dataSourceAppIdArray[selectedRow]];
    NSLog(@"%@",dictSelectedAppBundleInfo);
    self.selectedAppBundleInfo = dictSelectedAppBundleInfo;
    [self.tableView reloadData];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedAppBundleInfo.allKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.selectedAppBundleInfo allKeys][indexPath.row];
    NSString *info = self.selectedAppBundleInfo[key];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f]};
    CGRect rect = [info boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.bounds), CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return MAX(rect.size.height,70.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[InfoTableViewCell identifier]];
    NSString *key = [self.selectedAppBundleInfo allKeys][indexPath.row];
    
    [cell configureWithTitle:key andInfo:self.selectedAppBundleInfo[key]];
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

