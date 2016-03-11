//
//  RXTableViewCellDemoVC.m
//  RX.Kit
//
//  Created by 任玺 on 16/3/10.
//  Copyright © 2016年 Constantine. All rights reserved.
//

#import "RXTableViewCellDemoVC.h"
#import "RXExtendTableViewCell.h"

@interface RXTableViewCellDemoVC () <UITableViewDelegate, UITableViewDataSource, RXExtendTableViewCellDelegate>

@end

@implementation RXTableViewCellDemoVC
{
    NSArray *_dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = @[@"左滑1", @"左滑2", @"左滑3", @"左滑4"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TITLE_HEIGHT)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
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
    NSLog(@"didSelectRowAtIndexPath indexPath.section = %ld, indexPath.row = %ld", (long)indexPath.section, (long)indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRowsInSection = _dataArray.count;
    
    return numRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RXExtendTableViewCell *extendTableViewCell = [[RXExtendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                              reuseIdentifier:@"extendTableViewCell"
                                                                                 buttonTitles:@[@"删除", @"未读", @"收藏"]
                                                                                 buttonColors:@[UIColorFromRGB(0xf26861), UIColorFromRGB(0x73bf82), UIColorFromRGB(0xbfbfbf)]
                                                                                contentHeight:TABLEVIEW_CELL_HEIGHT
                                                                                    indexPath:indexPath
                                                                                     delegate:self];
    
    extendTableViewCell.textLabel.text = _dataArray[indexPath.row];
    
    return extendTableViewCell;
}

#pragma mark - RXExtendTableViewCellDelegate
-(void)buttonClicked:(NSInteger)tag indexPath:(NSIndexPath *)indexPath
{
    NSLog(@"buttonClicked tag = %ld, indexPath.section = %ld, indexPath.row = %ld", tag, (long)indexPath.section, (long)indexPath.row);
}

@end

