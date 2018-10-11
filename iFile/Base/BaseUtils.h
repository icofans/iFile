//
//  BaseUtils.h
//  iFile
//
//  Created by 王家强 on 2018/10/8.
//  Copyright © 2018 王家强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseUtils : NSObject

/** 获取ip地址 */
+ (NSString *)deviceIPAdress;

#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

@end

NS_ASSUME_NONNULL_END
