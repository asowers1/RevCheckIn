//
//  TeamInfoViewController.m
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/28/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "TeamInfoViewController.h"
#import "EmployeeTableViewCell.h"
#import "RevCheckIn-Swift.h"
#import "HTTPImage.h"
#import <MobileCoreServices/UTCoreTypes.h>

#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface TeamInfoViewController ()
{
    NSString *username;
    NSIndexPath *selected;
}

@end

@implementation TeamInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    username = @"";
    
    if (self.member){
        [self.control setSelectedSegmentIndex:1];
    } else {
        [self.control setSelectedSegmentIndex:0];
    }
    [self changeSubview:self.control];
    
    [self.logo.layer setCornerRadius:75];
    [self.logo.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.logo.layer setBorderWidth:5];
    [self.logo setImage:[self.team objectForKey:@"logo"]];
    
    [self.teamNameLabel setText:[self.team objectForKey:@"teamName"]];
    
    [self.bioLabel setText:[self.team objectForKey:@"bio"]];
    NSLog(@"Width: %f",self.employeeTable.frame.size.width);
    
    if (IPAD){
        [self setPreferredContentSize:CGSizeMake(320, 568)];
        [self.bioLabel setPreferredMaxLayoutWidth:320 - 16];
    } else {
        float screenWidth = self.navigationController.navigationBar.frame.size.width;
        [self.bioLabel setPreferredMaxLayoutWidth:screenWidth - 16];
    }
    
    [self.employeeTable setRowHeight:90];

    [self.employeeTable setDataSource:self];
 
    [self.employeeTable setDelegate:self];
    
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
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
}

-(void)viewDidAppear:(BOOL)animated{
    if (selected){
        [self.employeeTable selectRowAtIndexPath:selected animated:YES scrollPosition:UITableViewScrollPositionMiddle];
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
        
    if (self.member){
        if ([cell.nameLabel.text isEqualToString:self.member]){
            selected = indexPath;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 8){
        return YES;
    }
    return NO;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    
    UITableViewRowAction *call = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Call" handler:^(UITableViewRowAction *action, NSIndexPath *index){
        NSString *number;
        NSString *error;
        [[[ECPhoneNumberFormatter alloc] init] getObjectValue:&number forString:[[(EmployeeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] phoneLabel] text] errorDescription:&error];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", number]]];
        [tableView setEditing:NO animated:YES];
    }];
    [call setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(130/255.0) blue:(01/255.0) alpha:1]];
    UITableViewRowAction *email = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Email" handler:^(UITableViewRowAction *action, NSIndexPath *index){
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        [mail setMailComposeDelegate:self];
        [mail setToRecipients:@[[[(EmployeeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] emailLabel] text]]];
        [self presentViewController:mail animated:YES completion:nil];
        [tableView setEditing:NO animated:YES];
    }];
    [email setBackgroundColor:[UIColor colorWithRed:(232/255.0) green:(91/255.0) blue:(11/255.0) alpha:1]];
    UITableViewRowAction *text = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Text" handler:^(UITableViewRowAction *action, NSIndexPath *index){
        MFMessageComposeViewController *text = [[MFMessageComposeViewController alloc] init];
        [text setMessageComposeDelegate:self];
        [text setRecipients:@[[[(EmployeeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] phoneLabel] text]]];
        [self presentViewController:text animated:YES completion:nil];
        [tableView setEditing:NO animated:YES];
    }];
    [text setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(190/255.0) blue:(13/255.0) alpha:1]];
    [ret addObject:email];
    [ret addObject:call];
    [ret addObject:text];
    
    return ret;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [[(EmployeeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] emailLabel] restartLabel];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selected = indexPath;
    
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 8){
        [self.peek setHidden:NO];
        self.peekTop.constant = [tableView convertRect:[tableView rectForRowAtIndexPath:indexPath] toView:self.view].origin.y - tableView.frame.origin.y;
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
    } else {
        UIActionSheet *contactAction = [[UIActionSheet alloc] initWithTitle:@"Contact" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call", @"Mail", @"Text", nil];
        [contactAction showFromRect:self.view.frame inView:self.view animated:YES];
    }

}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if ([actionSheet.title isEqualToString:@"Change Logo"]){
        if (buttonIndex == 0){
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.delegate = self;
            [[picker navigationBar] setTintColor:[UIColor whiteColor]];
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [picker setMediaTypes:@[(NSString *) kUTTypeImage]];
            [picker setAllowsEditing:YES];
            [self presentViewController:picker animated:YES completion:nil];
        }
        
    } else if ([actionSheet.title isEqualToString:@"Contact"]){
        if (buttonIndex == 0){
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", [[(EmployeeTableViewCell *)[self.employeeTable cellForRowAtIndexPath:selected] phoneLabel] text]]]];
        } else if (buttonIndex == 1){
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            [mail setMailComposeDelegate:self];
            [mail setToRecipients:@[[[(EmployeeTableViewCell *)[self.employeeTable cellForRowAtIndexPath:selected] emailLabel] text]]];
            [self presentViewController:mail animated:YES completion:nil];
        } else if (buttonIndex == 2){
            MFMessageComposeViewController *text = [[MFMessageComposeViewController alloc] init];
            [text setMessageComposeDelegate:self];
            [text setRecipients:@[[[(EmployeeTableViewCell *)[self.employeeTable cellForRowAtIndexPath:selected] phoneLabel] text]]];
            [self presentViewController:text animated:YES completion:nil];
        }
    }
}

-(void)changeImage{
    
    
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 8){
        
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
            [picker setAllowsEditing:NO];
            [self presentViewController:picker animated:YES completion:nil];
            
        }];
        [alert addAction:cancel];
        [alert addAction:choose];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIActionSheet *changeLogo = [[UIActionSheet alloc] initWithTitle:@"Change Logo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Library", nil];
        [changeLogo showFromRect:self.view.frame inView:self.view animated:YES];
    }
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *newLogo = info[UIImagePickerControllerOriginalImage];
    [self.loadingIndicator setUp];
    
    [self.loadingIndicator changeText:@"uploading image..."];
    [self.loadingIndicator startAnimating];
    [self.logo setImage:newLogo];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [[[[HTTPImage alloc] init] setLogo:newLogo forTeam:username] isEqualToString:@"1"];
// Build handler for image load failure
        if (success){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loadingIndicator hide];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loadingIndicator changeText:@"upload failed"];
                [self.loadingIndicator fadeAway];
            });
        }
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
