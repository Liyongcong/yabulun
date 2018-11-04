//
//  SLUserModel.h
//
//  Created by SurgeLee on 2018/5/22.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLUserModel : NSObject<NSCoding>

// 卡号
@property (nonatomic, copy) NSString *CardID;
@property (nonatomic, copy) NSString *CardName;
@property (nonatomic, copy) NSString *Password;
// 等级
@property (nonatomic, copy) NSString *LevelName;
// 积分
@property (nonatomic, strong) NSNumber *Point;
// 金额
@property (nonatomic, strong) NSNumber *Money;
// 电话
@property (nonatomic, strong) NSString *Phone;

// 环信
@property (nonatomic, strong) NSString *emUserName;
@property (nonatomic, strong) NSString *emPassWord;
@property (nonatomic, strong) NSString *emNickName;

/**
 保存用户登录信息
 
 @return 是否保存成功
 */
- (BOOL)saveUser;

/**
 取出用户信息
 
 @return 用户信息
 */
+ (instancetype)achieveUser;

/**
 删除归档文件
 */
+ (BOOL)delUser;

@end
