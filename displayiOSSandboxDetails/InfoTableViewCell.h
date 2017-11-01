//
//  InfoTableViewCell.h
//  displayiOSSandboxDetails
//
//  Created by Ivan Rodriguez on 2017-11-01.
//  Copyright © 2017 dns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell

+ (UINib *)nib;
+ (NSString *)identifier;

- (void)configureWithTitle:(NSString *)title andInfo:(NSString *)info;

@end
