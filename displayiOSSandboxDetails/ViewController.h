//
//  ViewController.h
//  displayiOSSandboxDetails
//
//  Created by dns on 10/20/17.
//  Copyright © 2017 dns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>{
    NSMutableArray *stringArray;
    NSInteger selectedRow;
    
    
}


@property (weak, nonatomic) IBOutlet UIPickerView *app_picker;

@property (strong, nonatomic)NSArray *dataSourceArray;
@property (strong, nonatomic)NSArray *completeAppList;

- (IBAction)view_sandbox_button:(id)sender;


@end

