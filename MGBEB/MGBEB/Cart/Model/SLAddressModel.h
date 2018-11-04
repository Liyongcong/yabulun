//
//  SLAddressModel.h
//  MGBEB
//
//  Created by SurgeLee on 2018/7/6.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLAddressModel : NSObject

// id
@property (nonatomic, copy) NSString *idstr;

@property (nonatomic, copy) NSString *memberCode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *address;

@end
