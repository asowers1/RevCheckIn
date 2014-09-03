//
//  TeamBioTableViewController.m
//  RevCheckIn
//
//  Created by Calvin Chestnut on 9/3/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "TeamBioTableViewController.h"

@interface TeamBioTableViewController ()

@end

@implementation TeamBioTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textField setText:[[self.parent teamInfo] objectForKey:@"bio"]];
}

-(IBAction)save:(id)sender{
    [self.textField resignFirstResponder];
    UIAlertController *confirm = [UIAlertController alertControllerWithTitle:@"confirm bio" message:@"would you like to save your new team bio?" preferredStyle:UIAlertControllerStyleAlert];
    [confirm addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil]];
    [confirm addAction:[UIAlertAction actionWithTitle:@"save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
// Save new bio
    }]];
    [self presentViewController:confirm animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
