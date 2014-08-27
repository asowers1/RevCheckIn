//
//  AllTeamsViewController.h
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/26/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RevCheckIn-Swift.h"
#import "TeamMembersCollectionView.h"
#import "MemberCollectionViewCell.h"

@interface AllTeamsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *revLogo;
@property (weak, nonatomic) IBOutlet UITableView *teamsTable;

@property (strong, nonatomic) NSMutableDictionary *allTeams;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

@end
