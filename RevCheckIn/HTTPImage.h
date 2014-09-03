//
//  HTTPImage.h
//  RevCheckIn
//
//  Created by Andrew Sowers on 8/25/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HTTPImage : NSObject

/*
 *  setUserPicture
 *
 *  @PARAM UIImage: image, NSString: username
 *
 *  sends new user photo to server
 */
-(NSString *)setUserPicture:(UIImage *)image :(NSString*)username;

/*
 *  setLogo
 *
 *  @PARAM UIImage: image, NSString: username
 *
 *  sets a logo to a company server side
 */
-(NSString *)setLogo:(UIImage *)image forTeam:(NSString*)username;
@end
