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
#import "TransLoadingIndicator.h"
#import "MarqueeLabel.h"

@interface AllTeamsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *revLogo;
@property (weak, nonatomic) IBOutlet UITableView *teamsTable;
@property (strong, nonatomic) UIRefreshControl *refresh;
@property (weak, nonatomic) IBOutlet UIButton *anchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchorTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchorLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchorWidth;

@property (weak, nonatomic) IBOutlet TransLoadingIndicator *loadingView;

- (IBAction)logout:(id)sender;


@end
