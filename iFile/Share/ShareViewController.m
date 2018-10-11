//
//  ShareViewController.m
//  iFile
//
//  Created by 王家强 on 2018/10/8.
//  Copyright © 2018 王家强. All rights reserved.
//

#import "ShareViewController.h"
#import "BaseUploader.h"

@interface ShareViewController ()

@property(nonatomic,strong) UIView *statusView;

@property(nonatomic,strong) UIImageView *statusImageV;

@property(nonatomic,strong) UILabel *statusLabel;

@property(nonatomic,strong) UILabel *hitLabel;

@property(nonatomic,strong) UIButton *serverBtn;



@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    
    // Do any additional setup after loading the view.
    //设置导航栏透明
    [self.navigationController.navigationBar setTranslucent:true];
    //把背景设为空
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
    
    [self creatUI];
    
    [self setupStatus];
    
}

- (void)setupStatus
{
    if ([BaseUploader shareInstance].isConnect) {
        self.statusImageV.image = [UIImage imageNamed:@"wifi"];
        self.statusLabel.text = @"确保iPhone和PC处于同一局域网下";
        self.hitLabel.text = @"在PC浏览器中访问以下网址,使用过程请勿锁屏";
        self.serverBtn.userInteractionEnabled = NO;
        [self.serverBtn setTitle:[BaseUploader shareInstance].serverUrl forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(stopServer)];
    } else {
        self.statusImageV.image = [UIImage imageNamed:@"err"];
        self.statusLabel.text = @"点击下方按钮开启WIFI传输";
        self.hitLabel.text = @"";
        [self.serverBtn setTitle:@"点击开启WIFI传输" forState:UIControlStateNormal];
        self.serverBtn.userInteractionEnabled = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)creatUI
{
    self.statusView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
    [self.view addSubview:self.statusView];
    
    self.statusImageV.frame = CGRectMake((self.statusView.frame.size.width - 80)/2, 100, 100, 100);
    [self.statusView addSubview:self.statusImageV];
    
    self.statusLabel.frame = CGRectMake(40, CGRectGetMaxY(self.statusImageV.frame)+20, self.statusView.frame.size.width-80, 40);
    [self.statusView addSubview:self.statusLabel];
    
    self.hitLabel.frame = CGRectMake(40, CGRectGetMaxY(self.statusView.frame)+20, self.statusView.frame.size.width-80, 40);
    [self.view addSubview:self.hitLabel];
    
    self.serverBtn.frame = CGRectMake(40, CGRectGetMaxY(self.hitLabel.frame)+10, self.statusView.frame.size.width-80, 44);
    [self.view addSubview:self.serverBtn];
}

- (UIView *)statusView
{
    if (!_statusView) {
        _statusView = [[UIView alloc] init];
        _statusView.backgroundColor = [UIColor colorWithRed:95/255.0 green:166/255.0 blue:248/255.0 alpha:1];
    }
    return _statusView;
}

- (UIImageView *)statusImageV
{
    if (!_statusImageV) {
        _statusImageV = [[UIImageView alloc] init];
    }
    return _statusImageV;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.numberOfLines = 0;
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        // _statusLabel.text = @"确保iPhone和PC处于同一局域网下";
    }
    return _statusLabel;
}

- (UILabel *)hitLabel
{
    if (!_hitLabel) {
        _hitLabel = [[UILabel alloc] init];
        _hitLabel.numberOfLines = 0;
        _hitLabel.font = [UIFont systemFontOfSize:14];
        _hitLabel.textColor = [UIColor blackColor];
        _hitLabel.textAlignment = NSTextAlignmentCenter;
        // _statusLabel.text = @"确保iPhone和PC处于同一局域网下";
    }
    return _hitLabel;
}

- (UIButton *)serverBtn
{
    if (!_serverBtn) {
        _serverBtn = [[UIButton alloc] init];
        _serverBtn.backgroundColor = [UIColor colorWithRed:95/255.0 green:166/255.0 blue:248/255.0 alpha:1];
        _serverBtn.layer.cornerRadius = 22;
        _serverBtn.layer.masksToBounds = YES;
        [_serverBtn addTarget:self action:@selector(startServer) forControlEvents:UIControlEventTouchUpInside];
    }
    return _serverBtn;
}

- (void)startServer
{
    // 开启WIFI上传
    BOOL success = [[BaseUploader shareInstance] startServer:20000];
    if (success) {
        [self setupStatus];
    }
}

- (void)stopServer
{
    // 关闭WIFI上传
    BOOL success = [[BaseUploader shareInstance] stopServer];
    if (success) {
        [self setupStatus];
    }
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
