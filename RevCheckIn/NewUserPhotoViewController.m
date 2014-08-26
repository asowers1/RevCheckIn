//
//  NewUserPhotoViewController.m
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/26/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "NewUserPhotoViewController.h"

@interface NewUserPhotoViewController ()

@end

@implementation NewUserPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self.label setText:@"last step\nchoose a photo"];
    
    [self.imageView.layer setCornerRadius:self.imageView.bounds.size.width / 2.0];
    [self.imageView setClipsToBounds:YES];
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectPhoto:(id)sender {
    
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    if (sender == self.cameraButton){
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.mediaTypes =
    @[(NSString *) kUTTypeImage];
    
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
}

-(void)imagePickerController:
(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [self.imageView setImage:image];
    [self.uploadIndicator setHidden:NO];
    [self.uploadIndicator startAnimating];
    [self.cameraButton setUserInteractionEnabled:NO];
    [self.libraryButton setUserInteractionEnabled:NO];
    [self.skipButton setUserInteractionEnabled:NO];
    [self.label setText:@"uploading image"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self uploadImage:image];
}

-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)uploadImage:(UIImage *)imageIn{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        //Setting Entity to be Queried
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Active_user"
                                                  inManagedObjectContext:delegate.managedObjectContext];
        
        [fetchRequest setEntity:entity];
        NSError* error;
        
        // Query on managedObjectContext With Generated fetchRequest
        NSArray *fetchedRecords = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        NSString *userName = [fetchedRecords[0] valueForKey:@"username"];
        
        HTTPImage *imageUpload = [[HTTPImage alloc] init];
    
        [imageUpload setUserPicture:imageIn :userName];
        
#warning checkForFail
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.label setText:@"done"];
            [self.uploadIndicator setHidesWhenStopped:YES];
            [self.uploadIndicator stopAnimating];
            
            [self performSegueWithIdentifier:@"go" sender:self];

        });
    });
}

- (IBAction)skip:(id)sender {
    [self performSegueWithIdentifier:@"go" sender:self];
}
@end
