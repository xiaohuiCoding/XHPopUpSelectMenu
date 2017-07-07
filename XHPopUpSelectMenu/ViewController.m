//
//  ViewController.m
//  XHPopUpSelectMenu
//
//  Created by xiaohui on 2017/7/7.
//  Copyright © 2017年 XIAOHUI. All rights reserved.
//

#import "ViewController.h"
#import "PopUpSelectMenu.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *addButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.backgroundColor = [UIColor redColor];
    self.addButton.frame = CGRectMake(100, 100,  60, 30);
    [self.addButton setTitle:@"click" forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
}

- (void)show {
    PopUpSelectMenu *menu = [[PopUpSelectMenu alloc] init];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"小红", @"小明", @"小芳", nil];
    [menu showMenuWithTitle:@"请选择" data:array completion:^(NSInteger index) {
        
        [self.addButton setTitle:array[index] forState:UIControlStateNormal];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
