//
//  HTTPImage.m
//  RevCheckIn
//
//  Created by Andrew Sowers on 8/25/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "HTTPImage.h"
#import <Foundation/Foundation.h>
@implementation HTTPImage

-(NSString *)setUserPicture:(UIImage *)image :(NSString*)username
{
    NSLog(@"Image W: %.0f H: %.0f", image.size.height, image.size.width);
    image = [self imageWithImage:image scaledToSize:CGSizeMake(image.size.width / 2.0, image.size.height / 2.0)];
    NSLog(@"Image W: %.0f H: %.0f", image.size.height, image.size.width);
    NSData* imageData = UIImagePNGRepresentation(image);
    NSLog(imageData.description);
    NSString *urlString = [NSString stringWithFormat:@"http://experiencepush.com/rev/rest/index.php?PUSH_ID=123&call=setUserPicture&username=%@",username];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"%@.png\"\r\n",[[[username stringByReplacingOccurrencesOfString:@"." withString:@""] componentsSeparatedByString:@"@"] objectAtIndex:0]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    return returnString;
    
}

- (UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



@end
