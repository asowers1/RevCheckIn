//
//  UserStatusTableViewCell.m
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/22/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "UserStatusTableViewCell.h"

@implementation UserStatusTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUser:(NSManagedObject *)userIn{
    self.user = userIn;
    
    [self.userNameLabel setText:[self.user valueForKey:@"name"]];
    [self.userNameLabel setText:[self.user valueForKey:@"role"]];
    // Load State from wCoreData given User ManagedObject
    
    // Temp value
    NSString *state = @"in";
    
    if ([state isEqualToString:@"in"] || [state isEqualToString:@"out"]){
        
        [self.statusImage setImage:[UIImage imageNamed:state]];
        
        // Get Time status was updated
        NSString *time = @"9:05 AM";
        [self.timeLabel setText:time];
        
    } else {
        
        [self.statusImage setImage:[UIImage imageNamed:@"unknown"]];
        
    }
    
}

@end
