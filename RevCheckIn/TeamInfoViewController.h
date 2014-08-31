//
//  TeamInfoViewController.h
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/28/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransLoadingIndicator.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

@interface TeamInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *bioView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *control;
@property (weak, nonatomic) IBOutlet UITableView *employeeTable;
@property (weak, nonatomic) IBOutlet TransLoadingIndicator *loadingIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peekTop;
@property (weak, nonatomic) IBOutlet UIImageView *peek;

@property (strong, nonatomic) NSDictionary *team;
@property (strong, nonatomic) NSString *member;


- (IBAction)close:(id)sender;
- (IBAction)changeSubview:(id)sender;

@end
