//
//  TeamTableViewCell.m
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/26/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "TeamTableViewCell.h"

@implementation TeamTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [self.bar setHidden:NO];
    [self.bar setBackgroundColor:[UIColor colorWithRed:(254/255.0) green:(130/255.0) blue:(1/255.0) alpha:1]];
    // Configure the view for the selected state
}

@end
