//
//  HTTPImage.m
//  RevCheckIn
//
//  Created by Andrew Sowers on 8/25/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "HTTPImage.h"

@implementation HTTPImage


-(NSString *)uploadFileToServer:(NSString *)fileName

{
    /* creating path to document directory and appending filename with extension */
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSData *file1Data = [[NSData alloc] initWithContentsOfFile:filePath];
    NSString *urlString = @"http://experiencepush.com/rev/rest/?PUSH_ID=123&call=uploadImage";
    
    /* creating URL request to send data */
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    /* adding content as a body to post */
    
    NSMutableData *body = [NSMutableData data];
    NSString *header = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\".%@\"\r\n",[fileName stringByDeletingPathExtension],[fileName pathExtension]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:header] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:file1Data]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] ;
    return returnString;
}

@end
