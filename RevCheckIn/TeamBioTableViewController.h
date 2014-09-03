//
//  TeamBioTableViewController.h
//  RevCheckIn
//
//  Created by Calvin Chestnut on 9/3/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountTableViewController.h"

@interface TeamBioTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (strong, nonatomic) AccountTableViewController *parent;

@end
