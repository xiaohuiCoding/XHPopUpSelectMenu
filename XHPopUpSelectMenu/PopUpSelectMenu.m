//
//  PopUpSelectMenu.m
//  XHPopUpSelectMenu
//
//  Created by xiaohui on 2017/7/7.
//  Copyright © 2017年 XIAOHUI. All rights reserved.
//

#import "PopUpSelectMenu.h"

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define Self_Width self.bounds.size.width
#define Self_Height self.bounds.size.height
#define CommonHeight1 50
#define CommonHeight2 45

@interface PopUpSelectMenu() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *wrapView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, assign) NSInteger selectedIndexPath;

@end

@implementation PopUpSelectMenu

- (instancetype)init {
    
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Self_Width, Self_Height)];
    _backgroundView.backgroundColor = [UIColor blackColor];
    [self addSubview:_backgroundView];
    
    _wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Self_Width, Self_Height)];
    _wrapView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_wrapView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Self_Width, Self_Height)];
    _tableView.backgroundColor = [UIColor grayColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_wrapView addSubview:_tableView];
    
    // 设置默认cell的分割线左对齐(iOS7+)
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    //        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CommonHeight1)];
    headerView.backgroundColor = [UIColor cyanColor];
    _tableView.tableHeaderView = headerView;
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 19, 12, 12)];
    [cancleBtn setImage:[UIImage imageNamed:@"icon_box_canel"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancelSelect) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancleBtn];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, ScreenWidth - 100, headerView.frame.size.height)];
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_titleLabel];
    
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 50, 0, 35, 50)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureSelect) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sureButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelect)];
    [_backgroundView addGestureRecognizer:tap];
}

- (void)showMenuWithTitle:(NSString *)titleString data:(NSArray *)dataArray completion:(CellSelectedBlock)selectedBlock {
    
    _titleLabel.text = titleString;
    _dataSource = dataArray;
    _selectedBlock = selectedBlock;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGFloat newHeight = _dataSource.count*CommonHeight2 + CommonHeight1;
    _wrapView.frame = CGRectMake(0, Self_Height, Self_Width, newHeight);
    _backgroundView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _wrapView.frame = CGRectMake(0, Self_Height - newHeight, Self_Width, newHeight);
        _backgroundView.alpha = 0.6;
    }];
}

- (void)cancelSelect {
    
    CGFloat newHeight = _dataSource.count * CommonHeight2 + CommonHeight1;
    _wrapView.frame = CGRectMake(0, Self_Height - newHeight, Self_Width, newHeight);
    _backgroundView.alpha = 0.6;
    [UIView animateWithDuration:0.2 animations:^{
        _wrapView.frame = CGRectMake(0, Self_Height, Self_Width, newHeight);
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)sureSelect {
    
    _selectedBlock(_selectedIndexPath);
    [self cancelSelect];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CommonHeight2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setFrame:CGRectMake(0, 0, ScreenWidth, CommonHeight2)];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = self.dataSource[indexPath.row];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44.5, ScreenWidth, 0.5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [cell addSubview:lineLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndexPath = indexPath.row;
    [tableView reloadData];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor orangeColor];
}

@end
