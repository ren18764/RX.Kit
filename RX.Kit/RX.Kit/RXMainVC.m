//
//  ViewController.m
//  RX.Kit
//
//  Created by 任玺 on 16/3/8.
//  Copyright © 2016年 Constantine. All rights reserved.
//

#import "RXMainVC.h"
#import "RXTableViewCellDemoVC.h"
#import "RXBackSpaceTextFiledDemoVC.h"

@interface RXMainVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation RXMainVC
{
    UITableView *_demeTableView;
    NSArray *_demoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"demo集";

    _demoArray = @[@"支持侧滑显示N个按钮的tableCell",
                   @"输入数据为空时能够响应delete键的UITextField",
                   @"面包屑导航栏控件，用于数据多层级显示和跳转",
                   @"可全局统一关闭的ActionSheet"];
    
    _demeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TITLE_HEIGHT)];
    _demeTableView.delegate = self;
    _demeTableView.dataSource = self;
    [self.view addSubview:_demeTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = TABLEVIEW_CELL_HEIGHT;
    
    return heightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            RXTableViewCellDemoVC *tableViewCellDemoVC = [[RXTableViewCellDemoVC alloc] init];
            [self.navigationController pushViewController:tableViewCellDemoVC animated:YES];
        }
            break;
            
        case 1:{
            RXBackSpaceTextFiledDemoVC *backSpaceTextFiledDemoVC = [[RXBackSpaceTextFiledDemoVC alloc] init];
            [self.navigationController pushViewController:backSpaceTextFiledDemoVC animated:YES];
        }
            
            break;
            
        case 2:
            
            break;
            
        case 3:
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRowsInSection = _demoArray.count;

    return numRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *demoTableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"demoTableViewCell"];
    
    demoTableViewCell.textLabel.text = _demoArray[indexPath.row];
    
    return demoTableViewCell;
}

@end



