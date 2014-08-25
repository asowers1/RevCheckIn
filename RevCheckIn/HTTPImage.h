//
//  HTTPImage.h
//  RevCheckIn
//
//  Created by Andrew Sowers on 8/25/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPImage : NSObject
-(NSString *)uploadFileToServer:(NSString *)fileName;
@end
