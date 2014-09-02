//
//  EmployeeTableViewCell.h
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/28/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "ECPhoneNumberFormatter.h"
#import "MarqueeLabel.h"

@interface EmployeeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet MarqueeLabel *nameLabel;
@property (weak, nonatomic) IBOutlet MarqueeLabel *roleLabel;
@property (weak, nonatomic) IBOutlet MarqueeLabel *emailLabel;
@property (weak, nonatomic) IBOutlet MarqueeLabel *phoneLabel;

@property (strong, nonatomic) NSManagedObject *member;

-(void)passMember:(NSManagedObject *)memberIn;

@end
