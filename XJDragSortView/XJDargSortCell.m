//
//   XJDargSortCell.m
//
//
//  Created by Johnay  on 2019/5/21.
//  Copyright © 2019 SZUI. All rights reserved.
//

#import "XJDargSortCell.h"
#import "XJDragSortTool.h"
#import "UIView+Frame.h"
#import "XJDefine.h"

#define kDeleteBtnWH FitValue(10)

@interface XJDargSortCell ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)  UILabel *label;

@property (nonatomic,strong) UIButton * deleteBtn;
@end
@implementation XJDargSortCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    
    //给每个cell添加一个长按手势
    UILongPressGestureRecognizer * longPress =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
    longPress.delegate = self;
    [self addGestureRecognizer:longPress];
    
    UIPanGestureRecognizer * pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSubscribe)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    _label = [[UILabel alloc] init];
    [self.contentView addSubview:_label];
    _label.font = [UIFont systemFontOfSize:FitValue(14)];
    _label.textColor = RGBCOLOR(43, 51, 58);
    _label.layer.cornerRadius = FitValue(2);
    _label.backgroundColor = RGBCOLOR(249, 249, 249);

    _label.textAlignment = NSTextAlignmentCenter;
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImage:[UIImage imageNamed:@"hot_delete_icon"] forState:UIControlStateNormal];
    _deleteBtn.width = kDeleteBtnWH;
    _deleteBtn.height = kDeleteBtnWH;
    
    [_deleteBtn addTarget:self action:@selector(cancelSubscribe) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
}

- (void)cancelSubscribe {
    
    if (![XJDragSortTool shareInstance].isEditing || [self.subscribe isEqualToString:@"推荐"]) {
        
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(XJDargSortCellCancelSubscribe:)]) {
        [self.delegate XJDargSortCellCancelSubscribe:self.subscribe];
    }
}

- (void)showDeleteBtn {
    
    if([self.subscribe isEqualToString:@"推荐"]) {
        
        _deleteBtn.hidden = YES;
        
    }else {
        
        _deleteBtn.hidden = NO;
    }
    
}



- (void)setSubscribe:(NSString *)subscribe {
    
    _subscribe = subscribe;
    if([self.subscribe isEqualToString:@"推荐"]) {
        
        _deleteBtn.hidden = YES;
        
    }else {
        
        _deleteBtn.hidden = ![XJDragSortTool shareInstance].isEditing;
    }
    
    
    _label.text = subscribe;
//    _label.frame = self.frame;
    _label.width = self.width;
    _label.height = self.height;
    _label.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![XJDragSortTool shareInstance].isEditing) {
        return NO;
    }
    return YES;
}


- (void)gestureAction:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([self.subscribe isEqualToString:@"推荐"]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(XJDargSortCellGestureAction:)]) {
        [self.delegate XJDargSortCellGestureAction:gestureRecognizer];
    }
}

@end


