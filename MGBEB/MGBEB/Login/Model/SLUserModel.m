//
//  SLUserModel.m
//
//  Created by SurgeLee on 2018/5/22.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import "SLUserModel.h"

#import "SLHeader.h"

@implementation SLUserModel

- (BOOL)saveUser {
    // 0.获取根目录
    NSString *homeDictionary = NSHomeDirectory();
    // 1.获取沙河路径
    NSString *path = [homeDictionary stringByAppendingPathComponent:@"Documents/user.data"];
    SLLog(@"user保存 %@", path);
    // 2.将自己存储起来
    return [NSKeyedArchiver archiveRootObject:self toFile:path];
    
}

+ (instancetype)achieveUser {
    // 0.获取根目录
    NSString *homeDictionary = NSHomeDirectory();
    // 1.获取沙河路径
    NSString *path = [homeDictionary stringByAppendingPathComponent:@"Documents/user.data"];
    // 2.取出存储的模型对象
    SLUserModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    // 3.返回模型对象
    return user;
}

/**
 *  解码是调用，生成对象
 */
-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.CardID = [aDecoder decodeObjectForKey:@"CardID"];
        self.CardName = [aDecoder decodeObjectForKey:@"CardName"];
        self.Password = [aDecoder decodeObjectForKey:@"Password"];
        self.LevelName = [aDecoder decodeObjectForKey:@"LevelName"];
        self.Point = [aDecoder decodeObjectForKey:@"Point"];
        self.Money = [aDecoder decodeObjectForKey:@"Money"];
        self.emUserName = [aDecoder decodeObjectForKey:@"emUserName"];
        self.emPassWord = [aDecoder decodeObjectForKey:@"emPassWord"];
        self.emNickName = [aDecoder decodeObjectForKey:@"emNickName"];
    }
    return self;
}

/**
 *  归档，将对象元素进行归档
 */
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_CardID forKey:@"CardID"];
    [aCoder encodeObject:_CardID forKey:@"CardName"];
    [aCoder encodeObject:_Password forKey:@"Password"];
    [aCoder encodeObject:_LevelName forKey:@"LevelName"];
    [aCoder encodeObject:_Point forKey:@"Point"];
    [aCoder encodeObject:_Money forKey:@"Money"];
    [aCoder encodeObject:_Money forKey:@"emUserName"];
    [aCoder encodeObject:_Money forKey:@"emPassWord"];
    [aCoder encodeObject:_Money forKey:@"emNickName"];
}


// 删除归档文件
+ (BOOL)delUser {
    
    // 0.获取根目录
    NSString *homeDictionary = NSHomeDirectory();
    // 1.获取沙河路径
    NSString *path = [homeDictionary stringByAppendingPathComponent:@"Documents/user.data"];
    // 2.删除文件
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    return [fileManager removeItemAtPath:path error:nil];
}


@end
