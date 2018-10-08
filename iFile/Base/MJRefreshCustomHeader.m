//
//  MJRefreshCustomHeader.m
//  TZH_Project
//
//  Created by 王家强 on 2017/6/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MJRefreshCustomHeader.h"
#import "NSBundle+MJRefresh.h"

@interface LoadImageView : UIImageView

@property (nonatomic,assign) BOOL isRotating;

- (void)startRotating;

- (void)stopRotating;

@end

@implementation LoadImageView

static const CGFloat kAotoRotating = 0.04f;


- (void)startRotating {
    
    self.image = [UIImage imageNamed:@"ic_reload_rotate"];
    self.isRotating = YES;
    NSTimeInterval period = 0.02f; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (!self.isRotating) {
            dispatch_source_cancel(_timer);
            return ;
        }
        //在这里执行事件
        CGFloat degree = kAotoRotating * M_PI;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.transform = CGAffineTransformRotate(self.transform, degree);
        });
    });
    dispatch_resume(_timer);
}

- (void)stopRotating
{
    self.isRotating = NO;
    self.image = nil;
}


@end



@interface MJRefreshCustomHeader ()
{
    __unsafe_unretained UIImageView *_arrowView;
}
@property (weak, nonatomic) LoadImageView *loadingView;

@end

@implementation MJRefreshCustomHeader

#pragma mark - 懒加载子控件
- (UIImageView *)arrowView
{
    if (!_arrowView) {
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[NSBundle mj_arrowImage]];
        [self addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}

- (LoadImageView *)loadingView
{
    if (!_loadingView) {
        LoadImageView *loadingView = [[LoadImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
}

- (void)placeSubviews
{
    [super placeSubviews];
    self.lastUpdatedTimeLabel.hidden = YES;
    
    [self setTitle:@"下拉可刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"松开可刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"正在刷新中" forState:MJRefreshStateRefreshing];
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        CGFloat stateWidth = self.stateLabel.mj_textWith;
        CGFloat timeWidth = 0.0;
        if (!self.lastUpdatedTimeLabel.hidden) {
            timeWidth = self.lastUpdatedTimeLabel.mj_textWith;
        }
        CGFloat textWidth = MAX(stateWidth, timeWidth);
        arrowCenterX -= textWidth / 2 + self.labelLeftInset;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.mj_size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }
    
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
    
    self.arrowView.tintColor = self.stateLabel.textColor;
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                
                self.loadingView.alpha = 1.0;
                [self.loadingView stopRotating];
                self.arrowView.hidden = NO;
            }];
        } else {
            [self.loadingView stopRotating];
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
        }
    } else if (state == MJRefreshStatePulling) {
        [self.loadingView stopRotating];
        self.arrowView.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == MJRefreshStateRefreshing) {
        self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.loadingView startRotating];
        self.arrowView.hidden = YES;
    }
}

@end

@interface MJRefreshCustomFooter ()

@property (weak, nonatomic) LoadImageView *loadingView;

@end

@implementation MJRefreshCustomFooter

#pragma mark - 懒加载子控件
- (LoadImageView *)loadingView
{
    if (!_loadingView) {
        LoadImageView *loadingView = [[LoadImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}


#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    [self setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.loadingView.constraints.count) return;
    
    // 圈圈
    CGFloat loadingCenterX = self.mj_w * 0.5;
    if (!self.isRefreshingTitleHidden) {
        loadingCenterX -= self.stateLabel.mj_textWith * 0.5 + self.labelLeftInset;
    }
    CGFloat loadingCenterY = self.mj_h * 0.5;
    self.loadingView.center = CGPointMake(loadingCenterX, loadingCenterY);
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        [self.loadingView stopRotating];
    } else if (state == MJRefreshStateRefreshing) {
        [self.loadingView startRotating];
    }
}


@end
