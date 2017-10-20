//
//  ViewController.h
//  displayiOSSandboxDetails
//
//  Created by dns on 10/20/17.
//  Copyright © 2017 dns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h> //added to provide declaration for objc_getClass
#import "LSApplicationProxy.h"
#import "FBApplicationInfo.h"


@interface ViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>{
    NSMutableArray *stringArrayAppName;
    NSMutableArray *stringArrayAppid;
    NSInteger selectedRow;
   // NSMutableDictionary *all_apps;
   //  LSApplicationProxy *apps;


    
    
}


@property (weak, nonatomic) IBOutlet UIPickerView *app_picker;

@property (strong, nonatomic)NSArray *dataSourceArray;
@property (strong, nonatomic)NSArray *dataSourceAppIdArray;

@property (strong, nonatomic)NSArray *completeAppList;

- (IBAction)view_sandbox_button:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textview_sandbox_data_display;


@end

