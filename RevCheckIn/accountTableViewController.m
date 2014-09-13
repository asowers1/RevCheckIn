//
//  accountTableViewController.m
//  RevCheckIn
//
//  Created by Calvin Chestnut on 9/2/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "AccountTableViewController.h"
#import "HTTPImage.h"
#import "ECPhoneNumberFormatter.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "TeamBioTableViewController.h"

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
    NSLog(@"%@", [self.user valueForKeyPath:@"name"]);
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
    } else if (selected == self.changePasswordCell){
        [self changePassword];
    } else if (selected == self.changeNameCell){
        [self changeName];
    } else if (selected == self.changeRollCell){
        [self changeRole];
    } else if (selected == self.changeNumberCell){
        [self changeNumber];
    } else if (selected == self.changeBioCell){
        [self performSegueWithIdentifier:@"editBio" sender:self];
    }
}

-(void)updateName:(NSString *)nameIn andRole:(NSString *)roleIn andPhone:(NSString *)phoneIn{
    
    NSURL *newUrl = [NSURL URLWithString:@"http://experiencepush.com/rev/rest/"];
    NSString *username = [self.user valueForKey:@"username"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:newUrl];
        [req setHTTPMethod:@"POST"];
        NSString *body = [NSString stringWithFormat:@"username=%@&PUSH_ID=123&call=updateNameRolePhone&name=%@&role=%@&phone=%@", [username stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],[nameIn stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],[roleIn stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]],[phoneIn stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
        [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLResponse *response;
        NSError *error = nil;
        
        NSData *result = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
        NSString *check = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([check isEqualToString:@"1"]){
                [self.phoneDetailLabel setText:phoneIn];
                [self.roleDetailLabel setText:roleIn];
                [self.nameDetailLabel setText:nameIn];
                
                [[[HTTPHelper alloc] init] getAllUsers];
            } else {
                // Upload failed
                UIAlertController *fail = [UIAlertController alertControllerWithTitle:@"Change Failed" message:@"Try again later" preferredStyle:UIAlertControllerStyleAlert];
                [fail addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil]];
                
                [self presentViewController:fail animated:YES completion:nil];
            }
        });
        
    });
}

-(void)changeNumber{
    UIAlertController *number = [UIAlertController alertControllerWithTitle:@"Change Number" message:@"Enter your updated number. No formatting, just the digits" preferredStyle:UIAlertControllerStyleAlert];
    [number addTextFieldWithConfigurationHandler:^(UITextField *textField){
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        [textField setDelegate:self];
    }];
    [number addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [number addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *newRole = [[number textFields][0] text];
        if ([newRole isEqualToString:@""]){
            UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Invalid Number" message:@"Number cannot be empty" preferredStyle:UIAlertControllerStyleAlert];
            [error addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [error addAction:[UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self presentViewController:number animated:YES completion:nil];
            }]];
            [self presentViewController:error animated:YES completion:nil];
        } else {
            [self updateName:[self.nameDetailLabel text] andRole:[self.roleDetailLabel text] andPhone:[number.textFields[0] text]];
        }
    }]];
    [self presentViewController:number animated:YES completion:nil];
}

-(void)changeRole{
    UIAlertController *role = [UIAlertController alertControllerWithTitle:@"Change Role" message:@"Enter your updated role" preferredStyle:UIAlertControllerStyleAlert];
    [role addTextFieldWithConfigurationHandler:^(UITextField *textField){
        [textField setAutocorrectionType:UITextAutocorrectionTypeYes];
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    }];
    [role addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [role addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *newRole = [[role textFields][0] text];
        if ([newRole isEqualToString:@""]){
            UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Invalid Role" message:@"Role cannot be empty" preferredStyle:UIAlertControllerStyleAlert];
            [error addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [error addAction:[UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self presentViewController:role animated:YES completion:nil];
            }]];
            [self presentViewController:error animated:YES completion:nil];
        } else {
            [self updateName:[self.nameDetailLabel text] andRole:newRole andPhone:[self.phoneDetailLabel text]];
        }
    }]];
    [self presentViewController:role animated:YES completion:nil];
}

-(void)changeName{
    UIAlertController *name = [UIAlertController alertControllerWithTitle:@"Change Name" message:@"Enter your updated name" preferredStyle:UIAlertControllerStyleAlert];
    [name addTextFieldWithConfigurationHandler:^(UITextField *textField){
        [textField setAutocorrectionType:UITextAutocorrectionTypeYes];
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    }];
    [name addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [name addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *newName = [[name textFields][0] text];
        if ([newName isEqualToString:@""]){
            UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Invalid Name" message:@"Name cannot be empty" preferredStyle:UIAlertControllerStyleAlert];
            [error addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [error addAction:[UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self presentViewController:name animated:YES completion:nil];
            }]];
            [self presentViewController:error animated:YES completion:nil];
        } else {
            [self updateName:newName andRole:[self.roleDetailLabel text] andPhone:[self.phoneDetailLabel text]];
        }
    }]];
    [self presentViewController:name animated:YES completion:nil];
}

-(void)changePassword{
    UIAlertController *password = [UIAlertController alertControllerWithTitle:@"Change Password" message:@"Enter your current password" preferredStyle:UIAlertControllerStyleAlert];
    [password addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [password addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *currentPass = [[password textFields][0] text];
        if ([currentPass isEqualToString:@""]){
            UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Invalid Password" message:@"Password cannot be empty" preferredStyle:UIAlertControllerStyleAlert];
            [error addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [error addAction:[UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self presentViewController:password animated:YES completion:nil];
            }]];
            [self presentViewController:error animated:YES completion:nil];
        } else {
            NSString *username = [self.user valueForKey:@"username"];
            NSURL *checkPassURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://experiencepush.com/rev/rest/?username=%@&PUSH_ID=123&password=%@&call=login", [username stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]], currentPass]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSURLRequest *req = [NSURLRequest requestWithURL:checkPassURL];
                NSURLResponse *response;
                NSError *error = nil;
                
                NSData *result = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
                NSString *check = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([check isEqualToString:@"1"]){
                        UIAlertController *newPass = [UIAlertController alertControllerWithTitle:@"New Password" message:@"Enter your new password" preferredStyle:UIAlertControllerStyleAlert];
                        [newPass addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                        [newPass addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            NSString *pass = [[newPass textFields][0] text];
                            NSString *conf = [[newPass textFields][1] text];
                            if ([pass isEqualToString:@""]){
                                UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Invalid Password" message:@"Password cannot be empty" preferredStyle:UIAlertControllerStyleAlert];
                                [error addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                                [error addAction:[UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                    [self presentViewController:newPass animated:YES completion:nil];
                                }]];
                                [self presentViewController:error animated:YES completion:nil];
                            } else if ([pass isEqualToString:conf]){
                                NSURL *checkPassURL = [NSURL URLWithString:@"http://experiencepush.com/rev/rest/"];
                                
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    
                                    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:checkPassURL];
                                    [req setHTTPMethod:@"POST"];
                                    NSString *body = [NSString stringWithFormat:@"username=%@&PUSH_ID=123&call=updateUserPassword&oldPassword=%@&newPassword=%@&newPasswordCheck=%@", [username stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]], [currentPass stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]], [pass stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]], [conf stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
                                    [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                                    NSURLResponse *response;
                                    NSError *error = nil;
                                    
                                    NSData *result = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
                                    NSString *check = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if ([check isEqualToString:@"1"]){
                                            // Upload finished
                                            UIAlertController *finished = [UIAlertController alertControllerWithTitle:@"Finished" message:@"Your password has been updated" preferredStyle:UIAlertControllerStyleAlert];
                                            [finished addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil]];
                                            
                                            [self presentViewController:finished animated:YES completion:nil];
                                            
                                            [[[HTTPHelper alloc] init] getAllUsers];
                                        } else {
                                            // Upload failed
                                            UIAlertController *fail = [UIAlertController alertControllerWithTitle:@"Change Failed" message:@"Try again later" preferredStyle:UIAlertControllerStyleAlert];
                                            [fail addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil]];
                                            
                                            [self presentViewController:fail animated:YES completion:nil];
                                        }
                                    });
                                    
                                });
                            } else {
                                UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:@"Passwords do not match" preferredStyle:UIAlertControllerStyleAlert];
                                [error addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                                [error addAction:[UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                    [self presentViewController:newPass animated:YES completion:nil];
                                }]];
                                [self presentViewController:error animated:YES completion:nil];
                            }
                        }]];
                        [newPass addTextFieldWithConfigurationHandler:^(UITextField *textField){
                            [textField setPlaceholder:@"New password"];
                            [textField setSecureTextEntry:YES];
                        }];
                        [newPass addTextFieldWithConfigurationHandler:^(UITextField *textField){
                            [textField setPlaceholder:@"Confirm password"];
                            [textField setSecureTextEntry:YES];
                        }];
                        [self presentViewController:newPass animated:YES completion:nil];
                    } else {
                        UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Invalid Password" message:@"Password is incorrect" preferredStyle:UIAlertControllerStyleAlert];
                        [error addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                        [error addAction:[UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self presentViewController:password animated:YES completion:nil];
                        }]];
                        [self presentViewController:error animated:YES completion:nil];
                    }
                });
            });
        }
    }]];
    [password addTextFieldWithConfigurationHandler:^(UITextField *textField){
        [textField setPlaceholder:@"Password"];
        [textField setSecureTextEntry:YES];
    }];
    [self presentViewController:password animated:YES completion:nil];
};

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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([imageChanged isEqualToString:@"logo"]){
        
        UIImage *newLogo = info[UIImagePickerControllerEditedImage];
        
        self.loadingIndicator = [[TransLoadingIndicator alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2.0) - 75, (self.view.frame.size.height / 2.0) - 75, 150, 150)];
        [self.loadingIndicator setUp];
        [self.loadingIndicator startAnimating];
        
        [self.loadingIndicator changeText:@"uploading logo"];
        
        [self.navigationController.view addSubview:self.loadingIndicator];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            BOOL success = [[[[HTTPImage alloc] init] setLogo:newLogo forTeam:[self.user valueForKey:@"username"]] isEqualToString:@"1"];
            // Build handler for image load failure
            
            if (success){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.logo setImage:newLogo];
                    [self.loadingIndicator hide];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.loadingIndicator changeText:@"upload failed"];
                    [self.loadingIndicator fadeAway];
                });
            }
            
        });
    } else if ([imageChanged isEqualToString:@"photo"]){
        UIImage *newImage = info[UIImagePickerControllerEditedImage];
        
        self.loadingIndicator = [[TransLoadingIndicator alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2.0) - 75, (self.view.frame.size.height / 2.0) - 75, 150, 150)];
        [self.loadingIndicator setUp];
        [self.loadingIndicator startAnimating];
        
        [self.loadingIndicator changeText:@"uploading image"];
        
        [self.navigationController.view addSubview:self.loadingIndicator];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL success = [[[[HTTPImage alloc] init] setUserPicture:newImage :[self.user valueForKey:@"username"]] isEqualToString:@"1"];
            // Build handler for image load failure
            
            if (success){
                [[[HTTPHelper alloc] init] getAllUsers];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.loadingIndicator hide];
                    [self.profilePicView setImage:newImage];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.loadingIndicator changeText:@"upload failed"];
                    [self.loadingIndicator fadeAway];
                });
            }
            
        });
    }
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([actionSheet.title isEqualToString:@"Change Picture"]){
        if (buttonIndex == 0){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.delegate = self;
            [[picker navigationBar] setTintColor:[UIColor whiteColor]];
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [picker setMediaTypes:@[(NSString *) kUTTypeImage]];
            [picker setAllowsEditing:YES];
            [self presentViewController:picker animated:YES completion:nil];
        } else if (buttonIndex == 1){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.delegate = self;
            [[picker navigationBar] setTintColor:[UIColor whiteColor]];
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [picker setMediaTypes:@[(NSString *) kUTTypeImage]];
            [picker setAllowsEditing:YES];
            [self presentViewController:picker animated:YES completion:nil];
        }
    } else if ([actionSheet.title isEqualToString:@"Change Logo"]){
        if (buttonIndex == 0){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.delegate = self;
            [[picker navigationBar] setTintColor:[UIColor whiteColor]];
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [picker setMediaTypes:@[(NSString *) kUTTypeImage]];
            [picker setAllowsEditing:NO];
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

- (IBAction)clickDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickLogout:(id)sender {
    UIAlertController *confirm = [UIAlertController alertControllerWithTitle:@"Confirm Logout?" message:@"Are you sure you want to log out? This device won't update your check-in status until you log back in" preferredStyle:UIAlertControllerStyleAlert];
    [confirm addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [confirm addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        [self confirmLogout];
    }]];
    [self presentViewController:confirm animated:YES completion:nil];
}

-(void)confirmLogout{
    [[[HTTPHelper alloc] init] deleteActiveDevice];
    [[[HTTPHelper alloc] init] deleteActiveUser];
    [self performSegueWithIdentifier:@"logout" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"editBio"]){
        [(TeamBioTableViewController *)segue.destinationViewController setParent:self];
    }
}

@end
