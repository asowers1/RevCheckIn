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
    image = [self imageWithImage:image scaledToSize:[self getNewImageSize:image.size]];
    NSData* imageData = UIImagePNGRepresentation(image);
    //UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:imageData], nil, nil, nil);
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

-(NSString *)setLogo:(UIImage *)image forTeam:(NSString*)username
{
    image = [self imageWithImage:image scaledToSize:[self getNewImageSize:image.size]];
    NSData* imageData = UIImagePNGRepresentation(image);
    //UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:imageData], nil, nil, nil);
    NSString *urlString = [NSString stringWithFormat:@"http://experiencepush.com/rev/rest/index.php?PUSH_ID=123&call=setBusinessPicture&username=%@",username];
    
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
    
    NSLog(@"returnString:%@:",returnString);
    return returnString;
}

-(CGSize)getNewImageSize:(CGSize)sizeIn{
    CGFloat ratio;
    CGFloat height;
    CGFloat width;
    if (sizeIn.height >= sizeIn.width){
        ratio = sizeIn.width / sizeIn.height;
        height = 320;
        width = height * ratio;
    } else {
        ratio = sizeIn.height / sizeIn.width;
        width = 320;
        height = width * ratio;
    }
    return CGSizeMake(width, height);
    
}

- (UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



@end
