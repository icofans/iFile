//
//  UFileModel.h
//  iFile
//
//  Created by 王家强 on 2018/10/8.
//  Copyright © 2018 王家强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFileModel : NSObject

@property (nonatomic,strong) NSString *fileName;

@property (nonatomic,strong,readonly) NSString *filePath;

@property (nonatomic,strong,readonly) NSString *fileSize;

@end

NS_ASSUME_NONNULL_END
