//
//  UserInfoViewController.m
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/22/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.imageView setImage:[UIImage imageWithData:[self.user valueForKey:@"picture"]]];
    [self.nameLabel setText:[self.user valueForKey:@"name"]];
    
    [self setTitle:self.nameLabel.text];
    
    [self.teamLabel setText:[self.user valueForKey:@"business_name"]];
    [self.titleLabel setText:[self.user valueForKey:@"role"]];
    
    [self.emailButton setTitle:[NSString stringWithFormat:@"Call: %@",[self.user valueForKey:@"email"]] forState:UIControlStateNormal];
    [self.callButton setTitle:[NSString stringWithFormat:@"Email: %@",[self.user valueForKey:@"phone"]] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendEmail:(id)sender {
}

- (IBAction)call:(id)sender {
}

- (IBAction)clickShare:(id)sender {
}
@end
