//
//  UFileModel.m
//  iFile
//
//  Created by 王家强 on 2018/10/8.
//  Copyright © 2018 王家强. All rights reserved.
//

#import "UFileModel.h"

@implementation UFileModel


- (NSString *)filePath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:self.fileName];
    return filePath;
}

- (NSString *)fileSize
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:self.fileName];
    
    NSFileManager* manager =[NSFileManager
                             defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        long long length = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        float ff = length/1024.0/1024.0;
        if (ff < 1) {
            return [NSString stringWithFormat:@"%.0f KB",ff*100];
        } else {
            return [NSString stringWithFormat:@"%.2f MB",ff];
        }
    }
    return @"0 KB";
}




@end
