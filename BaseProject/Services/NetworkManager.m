//
//  NetworkManager.m
//  BaseProject
//
//  Created by Chung BD on 6/3/15.
//  Copyright (c) 2015 Bui Chung. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager
- (void) requestToServicesWithURL:(NSString*)url parameter:(NSDictionary *)para completion:(completionHandler)callback {
    NSLog(@"url: %@",url);
    NSLog(@"Parameter: %@",para);
    NSData *postData = [self convertToBodyRequestFromDictionary:para];
    NSString *postLength = [NSString stringWithFormat:@"%zd", [postData length]];
    
    _request = [[NSMutableURLRequest alloc] init];
    [_request setURL:[NSURL URLWithString:url]];
    [_request setHTTPMethod:@"POST"];
    [_request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:_request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response,NSData *data,NSError *error) {
                               [self verifyResponeData:response data:data error:error completion:^(ErrorCodes code, id result, id message) {
                                   callback(code,result,message);
                               }];
                           }];
}

- (void) verifyResponeData:(NSURLResponse *)response data:(NSData *)data error:(NSError *)error completion:(completionHandler)callback {
    if ([data length] >0 && error == nil){
        NSDictionary *serverRespone = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
        
        //        NSLog(@"data respone : %@",serverRespone);
        NSNumber *errorResponse = serverRespone[@"Status"];
        NSInteger errorCode = [errorResponse integerValue];
        if (errorCode == ErrorCodesOk) {
            callback(errorCode,serverRespone[@"data"],serverRespone[@"Message"]);
        }
        else if (errorCode == ErrorCodesServerResponseUnknow)
            callback(ErrorCodesServerResponseUnknow,nil,[NSString stringWithFormat:@"%@",serverRespone[@"Message"]]);
        else {
            callback(ErrorCodesRequestFault,nil, MSG_CHECK_INTERNET_CONNECTION);
        }
    }
    else if ([data length] == 0 && error == nil){
        NSLog(@"Nothing was downloaded.");
        callback(ErrorCodesRequestFault,nil,MSG_CHECK_INTERNET_CONNECTION);//MSG_ERROR_CODE_NOTHING_DOWNLOAD
    }
    else if (error != nil){
        NSLog(@"Error happened = %@", error);
        callback(ErrorCodesRequestFault,nil, MSG_CHECK_INTERNET_CONNECTION);//MSG_ERROR_CODE_UNKNOWN
    }
}

- (NSData*) convertToBodyRequestFromDictionary:(NSDictionary*)dic {
    NSMutableString *body = [NSMutableString new];
    [body appendString:[NSString stringWithFormat:@"api_key=%@",api_key]];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (body.length >0) {
            [body appendString:@"&"];
        }
        [body appendString:[NSString stringWithFormat:@"%@=%@",key,obj]];
    }];
    [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSData *postData = [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return postData;
}
@end
