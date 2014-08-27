//
//  TransLoadingIndicator.h
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/27/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TransLoadingIndicator : UIView


@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

-(void)setUp;

-(void)changeText:(NSString *)textIn;

-(void)startAnimating;

-(void)stopAnimating;

-(void)hide;

@end
