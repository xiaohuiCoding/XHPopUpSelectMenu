//
//  PopUpSelectMenu.h
//  XHPopUpSelectMenu
//
//  Created by xiaohui on 2017/7/7.
//  Copyright © 2017年 XIAOHUI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CellSelectedBlock)(NSInteger index);

@interface PopUpSelectMenu : UIView

@property (nonatomic, copy) CellSelectedBlock selectedBlock;

- (void)showMenuWithTitle:(NSString *)titleString data:(NSArray *)dataArray completion:(CellSelectedBlock)selectedBlock;

@end
