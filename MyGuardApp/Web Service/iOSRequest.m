//
//  iOSRequest.m
//  Mp-3
//
//  Created by HeLLs GAtE on 12/06/14.
//  Copyright (c) 2014 codebrew labs. All rights reserved.
//

#import "iOSRequest.h"
#import <AFNetworking.h>

@implementation iOSRequest
    


+(void)getStringResponse1 : (NSString *)urlStr type:(NSInteger)type success : (void (^)(NSString *responseStr))success failure:(void(^)(NSError* error))failure
{
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        success(str);        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [operation start];
    
}

+(void)getStringResponse : (NSString *)urlStr success : (void (^)(NSString *responseStr))success failure:(void(^)(NSError* error))failure
{
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
   
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        success(str);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

    [operation start];

}

+(void)getJsonResponse : (NSString *)urlStr success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSString * errorString))failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
      manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
    [manager GET:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        success(dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorString = NSLocalizedString(@"no_internet", nil);
        failure(errorString);
    }];
    
    
}






+(void)postMultipart : (NSDictionary *)parameters :(NSArray *)images :(NSString *)urlStr success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];


    
    manager.responseSerializer =  [AFHTTPResponseSerializer serializer];

    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
         
            [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
             {
                 UIImage *img = (UIImage *)[images objectAtIndex:idx];
                 NSData *data = UIImageJPEGRepresentation(img, 0.0);
                 [formData appendPartWithFileData: data name:@"image" fileName:@"temp.jpeg" mimeType:@"image/jpeg"];
                 
             }];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];

}

+(void)postImageAlarm : (NSString *)url parameters:(NSDictionary *)dparameters imageData:(NSData *)dimageData success: (void (^) (NSDictionary *responseStr))success failure: (void (^) (NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:dparameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:dimageData name:@"pic[0]" fileName:@"pic0.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // failure
        failure(error);
    }];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op start];
    
}

+(void)postVideoAlarm : (NSString *)url parameters:(NSDictionary *)dparameters videoData:(NSData *)dVideoData thumbData:(NSData *)thumbData success: (void (^) (NSDictionary *responseStr))success failure: (void (^) (NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:dparameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:dVideoData name:@"pic[0]" fileName:@"vid.mp4" mimeType:@"video/mp4"];
        [formData appendPartWithFileData:thumbData name:@"pic[1]" fileName:@"pic1.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // failure
        failure(error);
    }];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op start];
    
}
// 970
+(void)postNormalData :(NSDictionary *)parameters :(NSString *)urlStr  success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.responseSerializer =  [AFHTTPResponseSerializer serializer];

    //    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        success(dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
+(void)postNormalData1 :(NSDictionary *)parameters  str:(NSString *)urlStr  success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
    
    //    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         success(dict);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
}


+(void)uploadData : (NSString *)url parameters:(NSDictionary *)dparameters imageData:(NSData *)dimageData success: (void (^) (NSDictionary *responseStr))success failure: (void (^) (NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:dparameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        if(dimageData!=nil)
        [formData appendPartWithFileData:dimageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // failure
        failure(error);
    }];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op start];
    
}

@end
