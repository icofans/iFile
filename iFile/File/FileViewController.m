//
//  FileViewController.m
//  iFile
//
//  Created by 王家强 on 2018/10/8.
//  Copyright © 2018 王家强. All rights reserved.
//

#import "FileViewController.h"
#import "UFileModel.h"
#import "MJRefresh/MJRefresh.h"
#import "MJRefreshCustomHeader.h"
#import "BaseUploader.h"

@interface FileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *localFile;


@end

@implementation FileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"文件管理";
    
    
    [self.view addSubview:self.tableView];
    
    typeof(self) __weak weakSelf = self;
    self.tableView.mj_header = [MJRefreshCustomHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    // 添加监听
    [[BaseUploader shareInstance] addObserver:self forKeyPath:@"refresh" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
     [self loadData];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,[UIScreen mainScreen].bounds.size.height - 69 -44)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [UIView new];
    }
    return _tableView;
}

- (void)loadData
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
    NSString *fileName;
    _localFile = [NSMutableArray array];
    while (fileName = [dirEnum nextObject]) {
        UFileModel *model = [[UFileModel alloc] init];
        model.fileName = fileName;
        [_localFile addObject:model];
    }
    
    if (self.localFile.count) {
        self.tableView.backgroundView = nil;
    } else {
        UILabel *label = [[UILabel alloc] init];
        label.frame = self.tableView.backgroundView.bounds;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"无文件";
        self.tableView.backgroundView = label;
    }
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.localFile.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UFileModel *model = self.localFile[indexPath.row];
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = model.fileName;
    cell.detailTextLabel.text = model.fileSize;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除Documents文件夹下文件
        UFileModel *model = self.localFile[indexPath.row];
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:model.filePath error:nil];
        if (success) {
            [self.localFile removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)dealloc
{
    [[BaseUploader shareInstance] removeObserver:self forKeyPath:@"refresh"];
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
