//
//  EmployeeTableViewCell.m
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/28/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "EmployeeTableViewCell.h"

@implementation EmployeeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self.contentView setBackgroundColor:[UIColor whiteColor]];

    // Configure the view for the selected state
}

-(void)passMember:(NSManagedObject *)memberIn{
    self.member = memberIn;
    
    [self.userImage setImage:[UIImage imageWithData:[self.member valueForKey:@"picture"]]];
    [self.userImage setClipsToBounds:YES];
    [self.userImage.layer setCornerRadius:self.userImage.frame.size.width / 2.0];
    [self.nameLabel setText:[self.member valueForKey:@"name"]];
    [self.roleLabel setText:[self.member valueForKey:@"role"]];
    [self.emailLabel setText:[self.member valueForKey:@"email"]];
    [self.phoneLabel setText:[[[ECPhoneNumberFormatter alloc] init] stringForObjectValue:[self.member valueForKey:@"phone"]]];
    
    /*
    [self.nameLabel setMarqueeType:MLContinuous];
    [self.nameLabel setContinuousMarqueeExtraBuffer:20];
    [self.nameLabel setAnimationDelay:2];
    [self.nameLabel setRate:10];
    [self.nameLabel setFadeLength:5];
    
    [self.roleLabel setMarqueeType:MLContinuous];
    [self.roleLabel setContinuousMarqueeExtraBuffer:20];
    [self.roleLabel setAnimationDelay:2];
    [self.roleLabel setRate:10];
    [self.roleLabel setFadeLength:5];
     
    [self.emailLabel setMarqueeType:MLContinuous];
    [self.emailLabel setContinuousMarqueeExtraBuffer:20.0f];
    [self.emailLabel setRate:10.0f];
    [self.emailLabel setAnimationDelay:0];
    [self.emailLabel setFadeLength:5.0f];
     
    [self.phoneLabel setMarqueeType:MLContinuous];
    [self.phoneLabel setContinuousMarqueeExtraBuffer:20];
    [self.phoneLabel setAnimationDelay:2];
    [self.phoneLabel setRate:10];
    [self.phoneLabel setFadeLength:5];
    */
    
    if ([[self.member valueForKey:@"state"] isEqualToString:@"1"]){
        [self.statusImage setImage:[UIImage imageNamed:@"in"]];
    } else {
        [self.statusImage setImage:[UIImage imageNamed:@"out"]];
    }
}

@end
