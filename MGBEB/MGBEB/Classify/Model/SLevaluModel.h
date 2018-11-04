//
//  SLevaluModel.h
//  MGBEB
//
//  Copyright © 2018年 surge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLevaluModel : NSObject

// id
@property (nonatomic, copy) NSString *idstr;

@property (nonatomic, copy) NSString *memberCode;
@property (nonatomic, copy) NSString *evaluationContent;
@property (nonatomic, assign) NSInteger evaluationStar;
@property (nonatomic, copy) NSString *evaluationTime;

@end

NS_ASSUME_NONNULL_END
