//
//  EmployeeTableViewCell.h
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/28/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "ECPhoneNumberFormatter.h"

@interface EmployeeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (strong, nonatomic) NSManagedObject *member;

-(void)passMember:(NSManagedObject *)memberIn;

@end
