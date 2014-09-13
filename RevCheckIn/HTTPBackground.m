//
//  HTTPBackground.m
//  RevCheckIn
//
//  Created by Andrew Sowers on 8/21/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "HTTPBackground.h"
#import "RevCheckIn-Swift.h"


@implementation HTTPBackground


-(NSString*)getTimestamp
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSLog(@"%@",[DateFormatter stringFromDate:[NSDate date]]);
    
    
    return [DateFormatter stringFromDate:[NSDate date]];
    
}

- (void)updateUserState:(NSString*)username :(NSString*)state
{
    self.call  = @"updateUserState";
    self.state = state;
    
    NSString *appTimestamp = [self getTimestamp];
    NSLog(@"APP TIMESTAMP %@",appTimestamp);
    
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *config = [NSString stringWithFormat:@"com.experiencepush.state.transfer.%@",[uuid UUIDString]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:config];
    configuration.allowsCellularAccess = YES;
    
    _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://experiencepush.com/rev/rest/index.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"PUSH_ID=123&call=updateUserState&username=%@&state=%@&appTimestamp=%@",username,state,appTimestamp];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    _downloadTask = [self.session downloadTaskWithRequest:request];
    
    [_downloadTask resume];
}

- (void)getAllUsers
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HTTPHelper *helper = [[HTTPHelper alloc] init];
        [helper getAllUsers];
    });
}

- (void)linkUserToDevice:(NSString*)username :(NSString*)device
{
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *config=[NSString stringWithFormat:@"com.experiencepush.com.device.transfer.%@",[uuid UUIDString]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:config];
    configuration.allowsCellularAccess = YES;
    _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://experiencepush.com/rev/rest/index.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"PUSH_ID=123&call=linkDeviceToUser&username=%@&device=%@",username,device];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    _downloadTask = [self.session downloadTaskWithRequest:request];
    
    [_downloadTask resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)downloadURL
{
    NSLog(@"didFinishDownloadToURL: get reply");
    
    NSLog(@"url: %@",downloadURL);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *URLs =
    [fileManager URLsForDirectory:NSDocumentDirectory
                        inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [URLs objectAtIndex:0];
    
    NSURL *fromURL = [[downloadTask originalRequest] URL];
    NSURL *destinationURL =
    [documentsDirectory URLByAppendingPathComponent:[fromURL
                                                     lastPathComponent]];
    
    NSError *error;
    
    // Remove fil/Users/asow123/Desktop/RevCheckIn/RevCheckIn/usersTableViewController.swifte at the destination if it already exists.
    [fileManager removeItemAtURL:destinationURL error:NULL];
    
    BOOL success = [fileManager copyItemAtURL:downloadURL
                                        toURL:destinationURL error:&error];
    
    if (success)
    {
        NSLog(@"Background success");
        NSString * file = [[NSString alloc] initWithContentsOfFile:[destinationURL path] encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"FILE:%@:",file);
        if([self.call  isEqual: @"updateUserState"]&&[file isEqual:@"1"]){
            NSLog(@"updated user state");
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            CoreDataHelper *data = [[CoreDataHelper alloc] init];
            [data setUserStatus:self.state];
            if ([self.state isEqual:@"1"]){
                [appDelegate sendLocalNotificationWithMessage:@"Checking in"];
            }else if([self.state isEqual:@"0"]){
                [appDelegate sendLocalNotificationWithMessage:@"Checking out"];
            }
            [self getAllUsers];
        }else if([self.call isEqual:@"updateUserState"]&&[file isEqual:@"-2"]){
            NSLog(@"state overlap, got -2");
            CoreDataHelper *data = [[CoreDataHelper alloc] init];
            [data setUserStatus:self.state];
            [self getAllUsers];
        }
    }
    else
    {
        NSLog(@"File copy failed: %@", [error localizedDescription]);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error == nil)
    {
        NSLog(@"Task %@ completed successfully", task);
        
    }
    else
    {
        NSLog(@"Task %@ completed with error: %@", task,
              [error localizedDescription]);
    }
    _downloadTask = nil;
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.completionHandler) {
        void (^completionHandler)() = appDelegate.completionHandler;
        appDelegate.completionHandler = nil;
        completionHandler();
    }
    NSLog(@"Task complete");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
}
@end
