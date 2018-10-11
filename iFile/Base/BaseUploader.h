//
//  BaseUploader.h
//  iFile
//
//  Created by 王家强 on 2018/10/8.
//  Copyright © 2018 王家强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseUploader : NSObject

@property (nonatomic,assign,readonly) BOOL isConnect;

@property (nonatomic,assign,readonly) BOOL refresh;

@property (nonatomic,copy,readonly) NSString *serverUrl;

+ (instancetype)shareInstance;

- (BOOL)startServer:(NSUInteger)port;

- (BOOL)stopServer;

@end

NS_ASSUME_NONNULL_END
