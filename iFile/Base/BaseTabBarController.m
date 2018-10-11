//
//  BaseTabBarController.m
//  iFile
//
//  Created by 王家强 on 2018/10/8.
//  Copyright © 2018 王家强. All rights reserved.
//

#import "BaseTabBarController.h"
#import "FileViewController.h"
#import "ShareViewController.h"
#import "BaseNavigationController.h"
#import "BaseUploader.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewControllers];
    
    // 开启WIFI上传
//    [[BaseUploader shareInstance] startServer:20000];
}


#pragma mark 添加子控制器
- (void)addChildViewControllers
{
    
    UIViewController *homeVc = [[FileViewController alloc] init];
    [self addOneChlildVc:homeVc title:@"文件管理" imageName:@"tabbar_file_normal" selectedImageName:@"tabbar_file_select"];
    
    UIViewController *profileVc = [[ShareViewController alloc] init];
    [self addOneChlildVc:profileVc title:@"文件传输" imageName:@"tabbar_share_normal" selectedImageName:@"tabbar_share_select"];
    
}

#pragma mark 为子控制器设置样式
/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 设置标题
    childVc.title = title;
    
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:61/255.0 green:159/255.0 blue:249/255.0 alpha:1];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    // 添加为tabbar控制器的子控制器
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
