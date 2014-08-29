//
//  TeamInfoViewController.m
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/28/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "TeamInfoViewController.h"
#import "EmployeeTableViewCell.h"
#import "RevCheckIn-swift.h"
#import "HTTPImage.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface TeamInfoViewController ()
{
    NSString *username;
}

@end

@implementation TeamInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    username = @"";
    
    [self.control setSelectedSegmentIndex:[[NSNumber numberWithBool:self.member.boolValue] intValue]];
    [self changeSubview:self.control];
    
    [self setPreferredContentSize:CGSizeMake(320, 750)];
    
    [self.logo.layer setCornerRadius:75];
    [self.logo.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.logo.layer setBorderWidth:5];

    [self.employeeTable setRowHeight:90];

    [self.employeeTable setDataSource:self];
 
    [self.employeeTable setDelegate:self];
    self.navigationItem.titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 178, 39)];
    [(UIImageView *)self.navigationItem.titleView setContentMode:UIViewContentModeScaleAspectFit];
    [(UIImageView *)self.navigationItem.titleView setImage:[UIImage imageNamed:@"revWithText"]];
    
    NSManagedObjectContext *contect = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Active_user"];
    
    NSArray *actuveUserArray = [contect executeFetchRequest:fetch error:nil];
    if (actuveUserArray.count > 0){
        
        NSManagedObject *user = actuveUserArray[0];
        
        fetch = [[NSFetchRequest alloc] initWithEntityName:@"User"];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"username == %@", [user valueForKey:@"username"]];
        [fetch setPredicate:pred];
        
        NSArray *users = [contect executeFetchRequest:fetch error:nil];
        
        if (users.count > 0){
            user = users[0];
            
            if ([[user valueForKey:@"business_name"] isEqualToString:self.team[@"teamName"]]){
                username = [user valueForKey:@"username"];
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage)];
                [self.logo setUserInteractionEnabled:YES];
                [self.logo addGestureRecognizer:tapGesture];
            }
        }
        
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.member){
        [self.employeeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.member.integerValue inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    if (self.member){
        [self.employeeTable selectRowAtIndexPath:[NSIndexPath indexPathForItem:self.member.integerValue inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.team objectForKey:@"members"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EmployeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"employeeCell"];
    
    [cell passMember:[[self.team objectForKey:@"members"] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    
    UITableViewRowAction *call = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Call" handler:^(UITableViewRowAction *action, NSIndexPath *index){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://3014733513"]];
        [tableView setEditing:NO animated:YES];
    }];
    [call setBackgroundColor:[UIColor colorWithRed:(59/255.0) green:(197/255.0) blue:(58/255.0) alpha:1]];
    [ret addObject:call];
    UITableViewRowAction *email = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Email" handler:^(UITableViewRowAction *action, NSIndexPath *index){
        // Send Email
        [tableView setEditing:NO animated:YES];
    }];
    [email setBackgroundColor:[UIColor colorWithRed:(50/255.0) green:(161/255.0) blue:(249/255.0) alpha:1]];
    [ret addObject:email];
    
    return ret;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.peek setHidden:NO];
    self.peekTop.constant = [tableView rectForRowAtIndexPath:indexPath].origin.y;
    [tableView setBackgroundColor:[UIColor clearColor]];
    [UIView animateWithDuration:0.2f animations:^{
        
        [tableView cellForRowAtIndexPath:indexPath].frame = CGRectOffset([tableView cellForRowAtIndexPath:indexPath].frame, -40, 0);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2f animations:^{
            [tableView cellForRowAtIndexPath:indexPath].frame = CGRectOffset([tableView cellForRowAtIndexPath:indexPath].frame, 40, 0);
        } completion:^(BOOL finished){
            [tableView setBackgroundColor:[UIColor whiteColor]];
            [self.peek setHidden:YES];
        }];

    }];

}

-(void)changeImage{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change Logo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *choose = [UIAlertAction actionWithTitle:@"Choose From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        [[picker navigationBar] setTintColor:[UIColor whiteColor]];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [picker setMediaTypes:@[(NSString *) kUTTypeImage]];
        [picker setAllowsEditing:YES];
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    [alert addAction:cancel];
    [alert addAction:choose];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *newLogo = info[UIImagePickerControllerEditedImage];
    [self.loadingIndicator changeText:@"uploading image"];
    [self.loadingIndicator startAnimating];
    [self.logo setImage:newLogo];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *resp = [[[HTTPImage alloc] init] setLogo:newLogo forTeam:username];
// Build handler for image load failure
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingIndicator hide];
        });
    });
    
}

- (IBAction)close:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeSubview:(id)sender {
    switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
        case 0:
            [self.bioView setHidden:NO];
            [self.employeeTable setHidden:YES];
            break;
            
        case 1:
            [self.bioView setHidden:YES];
            [self.employeeTable setHidden:NO];
            break;
            
        default:
            break;
    }
}
@end
