//
//  SLNetWorkTools.m
//
//  Created by SurgeLee on 2018/5/19.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import "SLNetWorkTools.h"


// BaseURL
#define SLBaseUrl [NSURL URLWithString:@"http://222.128.63.143:9010/YBL-EB/"]

@implementation SLNetWorkTools

// 创建对象
+ (instancetype)shareNetworkTools
{
    // 单例
    static SLNetWorkTools *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        tools = [[SLNetWorkTools alloc] initWithBaseURL:SLBaseUrl sessionConfiguration:config];
        // 允许
        [tools.securityPolicy setAllowInvalidCertificates:YES];
        // 让AFN支持text/plain类型
        tools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"text/html", @"text/plain", @"application/json", @"text/json", @"text/javascript", nil];
        
//        tools.responseSerializer = [AFHTTPResponseSerializer serializer];
//        tools.requestSerializer = [AFHTTPRequestSerializer serializer];

    });
    return tools;
}

// 发起请求
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:( void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 由于原方法被弃用，返回AFN正在使用的方法
    return [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
}

// 发送json请求
+ (NSURLSessionDataTask *)JSONRequest:(NSString *)URLString
                           parameters:(NSString *)jsonString
                              success:(void (^)(id responseObject))success
                              failure:( void (^)(NSError *error))failure{
    
    NSError *error;

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://192.168.1.139:8080/other/adjustPoint" parameters:jsonString error:nil];

    req.timeoutInterval = [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];

    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];

    return [manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            success(responseObject);
        } else {
            failure(error);
        }
    }];
}

@end
