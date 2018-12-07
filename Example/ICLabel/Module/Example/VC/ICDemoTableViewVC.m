//
//  ICViewController.m
//  ICLabel
//
//  Created by iCrany on 10/08/2018.
//  Copyright (c) 2018 iCrany. All rights reserved.
//

#import "ICDemoTableViewVC.h"
#import <Masonry/Masonry.h>
#import "ICLabel_Example-Swift.h"

@interface ICDemoTableViewVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <DemoItemModel *> *dataSourceList;

@end

@implementation ICDemoTableViewVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"common"];
    
    [self prepareDataSource];
}

- (void)prepareDataSource {
    self.dataSourceList = [[NSMutableArray alloc] init];
    
    DemoItemModel *expendLabelModel = [[DemoItemModel alloc] initWithTitle:@"ICLabel Expend Demo" className:NSStringFromClass(ICExpendLabelDemoVC.class)];
    [self.dataSourceList addObject:expendLabelModel];
    
    DemoItemModel *icLineSpacingModel = [[DemoItemModel alloc] initWithTitle:@"ICLabel Line Spacing Demo" className:NSStringFromClass(ICLineSpacingDemoVC.class)];
    [self.dataSourceList addObject:icLineSpacingModel];
    
    DemoItemModel *lineSpacingModel = [[DemoItemModel alloc] initWithTitle:@"Line Spacing Bug Demo" className:NSStringFromClass(CoreTextLineSpacingVC.class)];
    [self.dataSourceList addObject:lineSpacingModel];
    
    DemoItemModel *tttAttributedModel = [[DemoItemModel alloc] initWithTitle:@"TTTAttributed Demo" className:NSStringFromClass(TTTAttributedLabelDemoVC.class)];
    [self.dataSourceList addObject:tttAttributedModel];
    
    DemoItemModel *yyTouchModel = [[DemoItemModel alloc] initWithTitle:@"YYLabel Touch Demo" className:NSStringFromClass(YYLabelTouchDemoVC.class)];
    [self.dataSourceList addObject:yyTouchModel];
    
    DemoItemModel *benchmarkModel = [[DemoItemModel alloc] initWithTitle:@"ICLabel Benchmark Demo" className:NSStringFromClass(ICLabelBenchmarkVC.class)];
    [self.dataSourceList addObject:benchmarkModel];
    
    DemoItemModel *lineBreakModeModel = [[DemoItemModel alloc] initWithTitle:@"LineBreakMode Demo" className:NSStringFromClass(ICLineBreakModeDemoVC.class)];
    [self.dataSourceList addObject:lineBreakModeModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoItemModel *model = self.dataSourceList[indexPath.row];
    
    Class clzz = NSClassFromString(model.className);
    if (clzz) {
        UIViewController *vc = [[clzz alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoItemModel *model = self.dataSourceList[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"common" forIndexPath:indexPath];
    cell.textLabel.text = model.title;
    
    return cell;
}


@end
