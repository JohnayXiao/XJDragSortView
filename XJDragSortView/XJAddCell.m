//
//  XJAddCell.m
//
//  Created by Johnay  on 2019/5/21.
//  Copyright © 2019 SZUI. All rights reserved.
//

#import "XJAddCell.h"

#import "XJDragSortTool.h"
#import "UIView+Frame.h"
#import "XJDefine.h"

#define kaddBtnWH FitValue(13)

@interface XJAddCell ()
@property (nonatomic,strong)  UILabel *label;

@property (nonatomic,strong) UIButton * addBtn;
@end
@implementation XJAddCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    self.backgroundColor = RGBCOLOR(249, 249, 249);
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setImage:[UIImage imageNamed:@"hot_add_icon"] forState:UIControlStateNormal];
    [_addBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_addBtn.titleLabel setFont:[UIFont systemFontOfSize:FitValue(14)]];
    [_addBtn setTitleColor:RGBCOLOR(43, 51, 58) forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addSubscribe) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addBtn];
}

- (void)addSubscribe {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(XJAddCellAddSubscribe:)]) {
        [self.delegate XJAddCellAddSubscribe:self.subscribe];
    }
}

- (void)setSubscribe:(NSString *)subscribe {
    
    _subscribe = subscribe;
    _addBtn.width = self.width;
    _addBtn.height = self.height;
    [_addBtn setTitle:subscribe forState:UIControlStateNormal];
    
}


@end

