//
//  MemberCollectionViewCell.h
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/26/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"

@interface MemberCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *memberImage;
@property (weak, nonatomic) IBOutlet MarqueeLabel *name;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UIImageView *maskImage;

@end
