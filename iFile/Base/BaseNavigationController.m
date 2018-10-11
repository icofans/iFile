//
//  BaseNavigationController.m
//  iFile
//
//  Created by 王家强 on 2018/10/8.
//  Copyright © 2018 王家强. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    
    // 清空弹出手势的代理，就可以恢复弹出手势
    self.interactivePopGestureRecognizer.delegate = self;
    
    // nav translucent
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}


#pragma mark tabbar二级界面隐藏
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];

    }
    [super pushViewController:viewController animated:animated];
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [super popViewControllerAnimated:animated];
    return vc;
}



- (void)back
{
    // warning 这里用的是self, 因为self就是当前正在使用的导航控制器
    [self.view endEditing:YES];
    [self popViewControllerAnimated:YES];
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    if ( gestureRecognizer == self.interactivePopGestureRecognizer )
    {
        if ( self.visibleViewController == [self.viewControllers objectAtIndex:0] )//让第一个子控制器侧滑时不产生作用
        {
            return NO;
        }
    }
    
    return YES;
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
