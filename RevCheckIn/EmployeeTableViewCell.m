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
    
    
    if ([[self.member valueForKey:@"state"] isEqualToString:@"1"]){
        [self.userImage.layer setBorderColor:[UIColor colorWithRed:(76/255.0) green:(217/255.0) blue:(100/255.0) alpha:1].CGColor];
        [self.userImage.layer setBorderWidth:2];
    } else {
        [self.userImage.layer setBorderWidth:0];
    }
}

@end
