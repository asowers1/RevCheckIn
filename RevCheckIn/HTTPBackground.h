//
//  HTTPBackground.h
//  RevCheckIn
//
//  Created by Andrew Sowers on 8/21/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPBackground : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>
@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURLSessionDownloadTask *downloadTask;

/*
 *  updateUserState
 *
 *  @PARAM NSString: username, NSString, state
 *
 *  sends new user state to server
 */
-(void)updateUserState:(NSString*)username :(NSString*)state;

/*
 *  linkUserToDevice
 *
 *  @PARAM NSString: username, NSString device(token id)
 *
 *  sends new device token id to server for updating
 */
-(void)linkUserToDevice:(NSString*)username :(NSString*)device;


-(void)getAllUsers;
@end
