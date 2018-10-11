//
//  BaseUploader.m
//  iFile
//
//  Created by 王家强 on 2018/10/8.
//  Copyright © 2018 王家强. All rights reserved.
//

#import "BaseUploader.h"
#import "GCDWebUploader.h"
#import "BaseUtils.h"

@interface BaseUploader ()<GCDWebUploaderDelegate>
{
    GCDWebUploader * _webServer;
}

@property (nonatomic,assign) BOOL refresh;

@end

@implementation BaseUploader

+ (instancetype)shareInstance
{
    static BaseUploader *uploader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uploader = [[BaseUploader alloc] init];
    });
    return uploader;
}

- (BOOL)startServer:(NSUInteger)port
{
    // 文件存储位置
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"文件存储位置 : %@", documentsPath);
    
    // 创建webServer，设置根目录
    _webServer = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
    // 设置代理
    _webServer.delegate = self;
    _webServer.allowHiddenItems = YES;
    
    // 限制文件上传类型
    // _webServer.allowedFileExtensions = @[@"doc", @"docx", @"xls", @"xlsx", @"txt", @"pdf"];
    // 设置网页标题
    _webServer.title = @"优小U-WIFI文件传输";
    // 设置展示在网页上的文字(开场白)
    _webServer.prologue = @"欢迎使用优小U-WIFI文件传输，点击上传文件按钮即可上传文件至App";
    // 设置展示在网页上的文字(收场白)
    _webServer.epilogue = @"";
    
    return [_webServer startWithPort:port bonjourName:@""];
}

- (BOOL)stopServer
{
    [_webServer stop];
    return YES;
}

- (NSString *)serverUrl
{
    return _webServer.serverURL.absoluteString;
}

- (BOOL)isConnect
{
    return _webServer.isRunning;
}


#pragma mark - <GCDWebUploaderDelegate>
- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
    NSLog(@"[UPLOAD] %@", path);
    
    self.refresh = YES;
    
//    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
}

- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    NSLog(@"[MOVE] %@ -> %@", fromPath, toPath);
    
    self.refresh = YES;
}

- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    NSLog(@"[DELETE] %@", path);
    
    self.refresh = YES;
//    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
}

- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    NSLog(@"[CREATE] %@", path);
    
    self.refresh = YES;
}




@end
