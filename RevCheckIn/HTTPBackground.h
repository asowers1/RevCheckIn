//
//  HTTPBackground.h
//  RevCheckIn
//
//  Created by Andrew Sowers on 8/21/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPBackground : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate,
NSURLSessionDownloadDelegate>
@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURLSessionDownloadTask *downloadTask;
@end
