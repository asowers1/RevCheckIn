//
//  TeamTableViewCell.h
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/26/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamMembersCollectionView.h"

@interface TeamTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *team;
@property (weak, nonatomic) IBOutlet UIImageView *teamImage;
@property (weak, nonatomic) IBOutlet TeamMembersCollectionView *teamMembers;

@end
