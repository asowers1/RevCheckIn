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


-(void)updateUserState:(NSString*)username :(NSString*)state
{
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *config = [NSString stringWithFormat:@"com.experiencepush.state.transfer.%@",[uuid UUIDString]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:config];
    configuration.allowsCellularAccess = YES;
    
    _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://experiencepush.com/rev/rest/index.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"PUSH_ID=123&call=updateUserState&username=%@&state=%@",username,state];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    _downloadTask = [self.session downloadTaskWithRequest:request];
    
    [_downloadTask resume];
}

-(void)linkUserToDevice:(NSString*)username :(NSString*)device
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
    
    // Remove file at the destination if it already exists.
    [fileManager removeItemAtURL:destinationURL error:NULL];
    
    BOOL success = [fileManager copyItemAtURL:downloadURL
                                        toURL:destinationURL error:&error];
    
    if (success)
    {
        NSString * file = [[NSString alloc] initWithContentsOfFile:[destinationURL path] encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"FILE:%@:",file);
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

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
}
@end
