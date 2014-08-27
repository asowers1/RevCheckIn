//
//  TransLoadingIndicator.m
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/27/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "TransLoadingIndicator.h"

@implementation TransLoadingIndicator {
    
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self setUp];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    [self setUp];
    
    return self;
}

-(void)setUp{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];;
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:self.bounds];
    [self addSubview:blurEffectView];
    
    // Vibrancy effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyEffectView setFrame:self.bounds];
    
    //Shoudl send subview to back?
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 108, 150, 42)];
    [self.textLabel setText:@"Label"];
    [self.textLabel setTextColor:[UIColor whiteColor]];
    [self.textLabel setTextAlignment:NSTextAlignmentCenter];
    [self.textLabel setNumberOfLines:2];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(56, 56, 37, 37)];
    [self.indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Add label to the vibrancy view
    [[vibrancyEffectView contentView] addSubview:self.textLabel];
    [[vibrancyEffectView contentView] addSubview:self.indicator];
    
    // Add the vibrancy view to the blur view
    [[blurEffectView contentView] addSubview:vibrancyEffectView];
    
    [self.layer setCornerRadius:25];
    [self setClipsToBounds:YES];
    
}

-(void)changeText:(NSString *)textIn{
    [self.textLabel setText:textIn];
}

-(void)startAnimating{
    if (self.hidden){
        [self setHidden:NO];
    }
    [self.indicator startAnimating];
}

-(void)stopAnimating{
    [self.indicator stopAnimating];
}

-(void)hide{
    [self stopAnimating];
    [self setHidden:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
