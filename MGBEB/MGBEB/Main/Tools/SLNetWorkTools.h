//
//  SLNetWorkTools.h
//
//  Created by SurgeLee on 2018/5/19.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface SLNetWorkTools : AFHTTPSessionManager

/**
 *  网络工具类单例
 *
 */
+ (instancetype)shareNetworkTools;


/**
 * 覆写自己的请求
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:( void (^)(NSURLSessionDataTask *task, NSError *error))failure;

// 发送Json数据
+ (NSURLSessionDataTask *)JSONRequest:(NSString *)URLString
                           parameters:(NSString *)jsonString
                              success:(void (^)(id responseObject))success
                              failure:( void (^)(NSError *error))failure;

@end
