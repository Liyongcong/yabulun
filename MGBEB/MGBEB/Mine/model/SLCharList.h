//
//  SLCharList.h
//  MGBEB
//
//  Created by 李博涛 on 2018/10/31.
//  Copyright © 2018 surge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLCharList : NSObject

@property (nonatomic, copy) NSString *idstr;

@property (nonatomic, copy) NSString *from_user;
@property (nonatomic, copy) NSString *to_user;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *lastTime;

@end

NS_ASSUME_NONNULL_END
