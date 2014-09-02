//
//  accountTableViewController.m
//  RevCheckIn
//
//  Created by Calvin Chestnut on 9/2/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "AccountTableViewController.h"
#import "HTTPImage.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface AccountTableViewController ()

@end

@implementation AccountTableViewController {
    NSString *imageChanged;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.profilePicView setImage:[UIImage imageWithData:[self.user valueForKey:@"picture"]]];
    [self.logo setImage:[self.teamInfo objectForKey:@"logo"]];
    
    [self.profilePicView setClipsToBounds:YES];
    [self.profilePicView.layer setCornerRadius:self.profilePicView.frame.size.width / 2.0];
    
    [self.logo setClipsToBounds:YES];
    [self.logo.layer setCornerRadius:self.logo.frame.size.width / 2.0];
    
    [self.nameDetailLabel setText:[self.user valueForKey:@"name"]];
    [self.roleDetailLabel setText:[self.user valueForKey:@"role"]];
    [self.phoneDetailLabel setText:[self.user valueForKey:@"phone"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *selected = [tableView cellForRowAtIndexPath:indexPath];
    if (selected == self.changePhotoCell){
        [self changePicture];
        imageChanged = @"photo";
    } else if (selected == self.changeLogoCell){
        [self changeLogo];
        imageChanged = @"logo";
    }
}

-(void)changePicture{
    
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 8){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change Picture" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *take = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.delegate = self;
            [[picker navigationBar] setTintColor:[UIColor whiteColor]];
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [picker setMediaTypes:@[(NSString *) kUTTypeImage]];
            [picker setAllowsEditing:YES];
            [self presentViewController:picker animated:YES completion:nil];
            
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
        [alert addAction:take];
        [alert addAction:choose];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIActionSheet *changeLogo = [[UIActionSheet alloc] initWithTitle:@"Change Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Picture", @"Choose From Library", nil];
        [changeLogo showFromRect:self.view.frame inView:self.view animated:YES];
    }
}

-(void)changeLogo{
    
    
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
            [picker setAllowsEditing:YES];
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([imageChanged isEqualToString:@"logo"]){
        
        UIImage *newLogo = info[UIImagePickerControllerEditedImage];
        [self.logo setImage:newLogo];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[[HTTPImage alloc] init] setLogo:newLogo forTeam:[self.user valueForKey:@"username"]];
            // Build handler for image load failure
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Show finished
            });
        });
    } else if ([imageChanged isEqualToString:@"photo"]){
        UIImage *newImage = info[UIImagePickerControllerEditedImage];
        [self.profilePicView setImage:newImage];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[[HTTPImage alloc] init] setUserPicture:newImage :[self.user valueForKey:@"username"]];
            // Build handler for image load failure
            [[[HTTPHelper alloc] init] getAllUsers];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Show finished
            });
        });
    }
    
    
}

- (IBAction)clickDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickLogout:(id)sender {
    UIAlertController *confirm = [UIAlertController alertControllerWithTitle:@"confirm logout?" message:@"are you sure you want to log out? this device won't update your check-in status until you log back in" preferredStyle:UIAlertControllerStyleAlert];
    [confirm addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil]];
    [confirm addAction:[UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        [self confirmLogout];
    }]];
    [self presentViewController:confirm animated:YES completion:nil];
}

-(void)confirmLogout{
    [[[HTTPHelper alloc] init] deleteActiveDevice];
    [[[HTTPHelper alloc] init] deleteActiveUser];
    [self performSegueWithIdentifier:@"logout" sender:self];
}

@end
