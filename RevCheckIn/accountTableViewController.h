//
//  accountTableViewController.h
//  RevCheckIn
//
//  Created by Calvin Chestnut on 9/2/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RevCheckIn-Swift.h"
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>

@interface AccountTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSDictionary *teamInfo;
@property (strong, nonatomic) NSManagedObject *user;

@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@property (weak, nonatomic) IBOutlet UILabel *nameDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneDetailLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *changePhotoCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *changePasswordCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *changeNameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *changeRollCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *changeNumberCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *changeLogoCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *changeBioCell;

- (IBAction)clickDone:(id)sender;
- (IBAction)clickLogout:(id)sender;
-(void)confirmLogout;

@end
