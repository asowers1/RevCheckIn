//
//  UserInfoViewController.h
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/22/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface UserInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

@property (strong, nonatomic) NSManagedObject *user;

- (IBAction)sendEmail:(id)sender;
- (IBAction)call:(id)sender;
- (IBAction)clickShare:(id)sender;

@end
