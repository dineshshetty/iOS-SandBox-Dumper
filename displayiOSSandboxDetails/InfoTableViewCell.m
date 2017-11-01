//
//  InfoTableViewCell.m
//  displayiOSSandboxDetails
//
//  Created by Ivan Rodriguez on 2017-11-01.
//  Copyright © 2017 dns. All rights reserved.
//

#import "InfoTableViewCell.h"

@interface InfoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *info;

@end

@implementation InfoTableViewCell

+ (UINib *)nib {
    return [UINib nibWithNibName:[self identifier] bundle:nil];
}

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.title.text = nil;
    self.info.text = nil;
}

- (void)configureWithTitle:(NSString *)title andInfo:(NSString *)info {
    self.title.text = title;
    self.info.text = info;
}

@end
