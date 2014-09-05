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
    [self.textField setDelegate:self];
    
    [self setTitle:[NSString stringWithFormat:@"%lu / 2048", (long)self.textField.text.length]];
}

-(void)textViewDidChange:(UITextView *)textView{
    [self setTitle:[NSString stringWithFormat:@"%lu / 2048", (long)self.textField.text.length]];
}

-(IBAction)save:(id)sender{
    [self.textField resignFirstResponder];
    UIAlertController *confirm = [UIAlertController alertControllerWithTitle:@"Confirm bio" message:@"Would you like to save your new team bio?" preferredStyle:UIAlertControllerStyleAlert];
    [confirm addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [confirm addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *username = [(NSManagedObject *)self.parent.user valueForKey:@"username"];
        NSURL *checkPassURL = [NSURL URLWithString:@"http://experiencepush.com/rev/rest/"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:checkPassURL];
            [req setHTTPMethod:@"POST"];
            NSString *body = [NSString stringWithFormat:@"username=%@&PUSH_ID=123&call=updateComanyBio&companyBio=%@", [username stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]], self.textField.text];
            [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
            NSURLResponse *response;
            NSError *error = nil;
            
            NSData *result = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
            NSString *check = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([check isEqualToString:@"1"]){
// Upload finished
                    UIAlertController *finished = [UIAlertController alertControllerWithTitle:@"Finished" message:@"Your bio has been updated" preferredStyle:UIAlertControllerStyleAlert];
                    [finished addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        [self.navigationController popViewControllerAnimated:YES];
                    }]];
                    
                    [self presentViewController:finished animated:YES completion:nil];
                    
                    [[[HTTPHelper alloc] init] getAllUsers];
                } else {
// Upload failed
                    UIAlertController *fail = [UIAlertController alertControllerWithTitle:@"Upload Failed" message:@"Try again later" preferredStyle:UIAlertControllerStyleAlert];
                    [fail addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil]];
                    
                    [self presentViewController:fail animated:YES completion:nil];
                }
            });
            
        });
// Save new bio
    }]];
    [self presentViewController:confirm animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
