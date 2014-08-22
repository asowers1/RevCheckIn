//
//  allUsersTableViewController.m
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/22/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "allUsersTableViewController.h"
#import "RevCheckIn-Swift.h"
#import "UserStatusTableViewCell.h"
#import "UserInfoViewController.h"

@interface allUsersTableViewController ()

@end

@implementation allUsersTableViewController {
    NSDictionary *allTeams;
    NSManagedObject *selectedUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setRowHeight:68];
    
    // Get Dictionary of Users with BusinessName as Key
    
    allTeams = [[NSMutableDictionary alloc] init];
    
    HTTPHelper *helper = [[HTTPHelper alloc] init];
    
    [helper getAllUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)loadUsers{
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:delegate.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *record in fetchedRecords){
        if ([allTeams valueForKey:[record valueForKey:@"business_name"]]){
            [[allTeams valueForKey:[record valueForKey:@"business_name"]] addObject:record];
        } else {
            NSMutableArray *new = [NSMutableArray arrayWithObject:record];
            [allTeams setValue:new forKey:[record valueForKey:@"business_name"]];
        }
    }
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return allTeams.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[allTeams valueForKey:[[allTeams allKeys] objectAtIndex:section]] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[allTeams allKeys] objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userStatusCell" forIndexPath:indexPath];
    
    NSManagedObject *user = [[allTeams valueForKey:[[allTeams allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [cell setUser:user];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    selectedUser = [[allTeams valueForKey:[[allTeams allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"showUserDetails" sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showUserDetails"]){
        [(UserInfoViewController *)segue.destinationViewController setUser:selectedUser];
    }
}

@end
