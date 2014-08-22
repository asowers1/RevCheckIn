//
//  allUsersTableViewController.h
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/22/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface allUsersTableViewController : UITableViewController

@property (strong, nonatomic) NSString *activeUsername;
@property (strong, nonatomic) NSManagedObject *activeUser;
@property (strong, nonatomic) CLBeacon *beacon;

@end
