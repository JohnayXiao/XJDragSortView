//
//   XJDragSortViewController.m
//
//
//  Created by Johnay  on 2019/5/21.
//  Copyright © 2019 SZUI. All rights reserved.
//
#import "XJDragSortViewController.h"
#import "XJDragSortTool.h"
#import "XJDargSortCell.h"
#import "XJAddCell.h"
#import "UIView+Frame.h"
#import "XJDefine.h"



@interface XJDragSortViewController ()<UICollectionViewDataSource,SKDragSortDelegate,XJDragSortDelegate, UICollectionViewDelegate>

@property (nonatomic,strong) UIView * topView;
@property (nonatomic,strong) UIView * recommendTopView;
@property (nonatomic,strong) UICollectionView * dragSortView;
@property (nonatomic,strong) UICollectionView * recommendCollectionView;
@property (nonatomic,strong) UIView * snapshotView; //截屏得到的view
@property (nonatomic,weak) XJDargSortCell * originalCell;
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,strong) NSIndexPath * nextIndexPath;
@property (nonatomic,strong) UIButton * sortDeleteBtn;

@property (nonatomic,strong) NSMutableArray * subscribeArray;
@property (nonatomic,strong) NSMutableArray * recommendArray;

@end

@implementation XJDragSortViewController

- (NSMutableArray *)recommendArray {
    
    if (!_recommendArray) {
        _recommendArray = [@[@"视频",@"军事",@"娱乐",@"问答",@"娱乐",@"汽车",@"段子"] mutableCopy];
    }
    return _recommendArray;
}

- (NSMutableArray *)subscribeArray {
    
    if (!_subscribeArray) {
        
        _subscribeArray = [@[@"推荐",@"趣图",@"财经",@"热点",@"房产",@"社会",@"数码",@"美女"] mutableCopy];
    }
    return _subscribeArray;
}

- (void)adjustFrame {
    
    if (self.subscribeArray.count) {
        
        NSInteger rowLines = (self.subscribeArray.count - 1) / 4 + 1;
        
        self.dragSortView.height = rowLines * FitValue(36) + (rowLines + 2) * FitValue(12);
    }
    
    self.recommendTopView.top = self.dragSortView.bottom;
    
    self.recommendCollectionView.top = self.recommendTopView.bottom;
    
    if (self.recommendArray.count) {
        
        NSInteger rowLines = (self.recommendArray.count - 1) / 4 + 1;
        self.recommendCollectionView.height = rowLines * FitValue(36) + (rowLines + 2) * FitValue(12);
    }
    
    _sortDeleteBtn.hidden = self.subscribeArray.count == 1;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"热点";
    [self.view addSubview:self.topView];
    [self.view addSubview:self.dragSortView];
    [self.view addSubview:self.recommendTopView];
    [self.view addSubview:self.recommendCollectionView];

    [self adjustFrame];
}

#pragma mark - collectionView dataSouce

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.dragSortView) {
        
        return self.subscribeArray.count;
    }
    
    return self.recommendArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.dragSortView) {
        
        XJDargSortCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XJDargSortCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.subscribe = self.subscribeArray[indexPath.row];
        return cell;
    }
    
    XJAddCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XJAddCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.subscribe = self.recommendArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.recommendCollectionView) {
        
        NSString *str = self.recommendArray[indexPath.row];
        [self.subscribeArray addObject:str];
        [self.recommendArray removeObjectAtIndex:indexPath.row];
        
        [self.dragSortView reloadData];
        [self.recommendCollectionView reloadData];
        [self adjustFrame];
    }
}

#pragma mark - SKDragSortDelegate

- (void)XJDargSortCellGestureAction:(UIGestureRecognizer *)gestureRecognizer{
    
    //记录上一次手势的位置
    static CGPoint startPoint;
    //触发长按手势的cell
    XJDargSortCell * cell = (XJDargSortCell *)gestureRecognizer.view;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        //开始长按
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            
            [XJDragSortTool shareInstance].isEditing = YES;
            [_sortDeleteBtn setTitle:@"完成" forState:UIControlStateNormal];
            self.dragSortView.scrollEnabled = NO;
        }
        
        if (![XJDragSortTool shareInstance].isEditing) {
            return;
        }
        
        NSArray *cells = [self.dragSortView visibleCells];
        for (XJDargSortCell *cell in cells) {
            [cell showDeleteBtn];
        }
        
        //获取cell的截图
        _snapshotView  = [cell snapshotViewAfterScreenUpdates:YES];
        _snapshotView.center = cell.center;
        [_dragSortView addSubview:_snapshotView];
        _indexPath = [_dragSortView indexPathForCell:cell];
        _originalCell = cell;
        _originalCell.hidden = YES;
        startPoint = [gestureRecognizer locationInView:_dragSortView];
        
        //移动
    }else if (gestureRecognizer.state == UIGestureRecognizerStateChanged){
        
        CGFloat tranX = [gestureRecognizer locationOfTouch:0 inView:_dragSortView].x - startPoint.x;
        CGFloat tranY = [gestureRecognizer locationOfTouch:0 inView:_dragSortView].y - startPoint.y;
        
        //设置截图视图位置
        _snapshotView.center = CGPointApplyAffineTransform(_snapshotView.center, CGAffineTransformMakeTranslation(tranX, tranY));
        startPoint = [gestureRecognizer locationOfTouch:0 inView:_dragSortView];
        //计算截图视图和哪个cell相交
        for (UICollectionViewCell *cell in [_dragSortView visibleCells]) {
            //跳过隐藏的cell
            if ([_dragSortView indexPathForCell:cell] == _indexPath) {
                continue;
            }
            //计算中心距
            CGFloat space = sqrtf(pow(_snapshotView.center.x - cell.center.x, 2) + powf(_snapshotView.center.y - cell.center.y, 2));
            
            //如果相交一半且两个视图Y的绝对值小于高度的一半就移动
            if (space <= _snapshotView.bounds.size.width * 0.5 && (fabs(_snapshotView.center.y - cell.center.y) <= _snapshotView.bounds.size.height * 0.5)) {
                _nextIndexPath = [_dragSortView indexPathForCell:cell];
                
                if (_nextIndexPath.row == 0) {
                    continue;
                }
                if (_nextIndexPath.item > _indexPath.item) {
                    for (NSUInteger i = _indexPath.item; i < _nextIndexPath.item ; i ++) {
                        [self.subscribeArray exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
                    }
                }else{
                    for (NSUInteger i = _indexPath.item; i > _nextIndexPath.item ; i --) {
                        [self.subscribeArray exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
                    }
                }
                //移动
                [_dragSortView moveItemAtIndexPath:_indexPath toIndexPath:_nextIndexPath];
                //设置移动后的起始indexPath
                _indexPath = _nextIndexPath;
                break;
            }
        }
        //停止
    }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        [_snapshotView removeFromSuperview];
        _originalCell.hidden = NO;
    }
}

- (void)XJDargSortCellCancelSubscribe:(NSString *)subscribe {
    
    for (NSString *str in self.subscribeArray) {
        
        if ([str isEqualToString:subscribe]) {
            
            [self.recommendArray insertObject:str atIndex:0];
            [self.subscribeArray removeObject:str];
            break;
        }
    }
    
    [self.dragSortView reloadData];
    [self.recommendCollectionView reloadData];
    [self adjustFrame];
}

- (void)XJAddCellAddSubscribe:(NSString *)subscribe {
    
    for (NSString *str in self.recommendArray) {
        
        if ([str isEqualToString:subscribe]) {
            
            [self.subscribeArray addObject:str];
            [self.recommendArray removeObject:str];
            break;
        }
    }
    
    [self.dragSortView reloadData];
    [self.recommendCollectionView reloadData];
    [self adjustFrame];
}
- (UIView *)topView {
    
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, XJ_NavigationBarHeight, XJ_ScreenWidth, FitValue(40))];
        _topView.backgroundColor = [UIColor whiteColor];
                
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FitValue(12), FitValue(14), FitValue(60), FitValue(30))];
        titleLabel.font = [UIFont systemFontOfSize:FitValue(16)];
        titleLabel.text = @"我的热点";
        [titleLabel sizeToFit];
        titleLabel.textColor = RGBCOLOR(72, 77, 80);
        [_topView addSubview:titleLabel];
        
        UIButton *  finshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finshBtn.frame = CGRectMake(XJ_ScreenWidth - FitValue(72), FitValue(10), FitValue(60), FitValue(30));
        [_topView addSubview:finshBtn];
        [finshBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [finshBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        finshBtn.titleLabel.font = titleLabel.font;
        finshBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [finshBtn addTarget:self action:@selector(finshClick) forControlEvents:UIControlEventTouchUpInside];
        _sortDeleteBtn = finshBtn;
        
    }
    return _topView;
}

- (UIView *)recommendTopView {
    
    if (!_recommendTopView) {
        _recommendTopView = [[UIView alloc] initWithFrame:CGRectMake(0, XJ_NavigationBarHeight, XJ_ScreenWidth, FitValue(40))];
        _recommendTopView.backgroundColor = [UIColor whiteColor];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FitValue(12), FitValue(14), FitValue(60), FitValue(30))];
        titleLabel.font = [UIFont systemFontOfSize:FitValue(16)];
        titleLabel.text = @"推荐热点";
        [titleLabel sizeToFit];
        titleLabel.textColor = RGBCOLOR(72, 77, 80);
        [_recommendTopView addSubview:titleLabel];
    
    }
    return _recommendTopView;
}

- (void)finshClick {
    
    [XJDragSortTool shareInstance].isEditing = ![XJDragSortTool shareInstance].isEditing;
    NSString * title = [XJDragSortTool shareInstance].isEditing ? @"完成":@"编辑";
    
    self.dragSortView.scrollEnabled = ![XJDragSortTool shareInstance].isEditing;
    [_sortDeleteBtn setTitle:title forState:UIControlStateNormal];
    
    [self.dragSortView reloadData];
    
}


- (UICollectionView *)dragSortView {
    
    if (!_dragSortView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(FitValue(80), FitValue(36));
//        layout.minimumLineSpacing = kSpaceBetweenSubscribe;
//        layout.minimumInteritemSpacing = kVerticalSpaceBetweenSubscribe;
        layout.sectionInset = UIEdgeInsetsMake(FitValue(8), kContentLeftAndRightSpace, kContentLeftAndRightSpace, kContentLeftAndRightSpace);
        _dragSortView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, XJ_ScreenWidth, XJ_ScreenHeight - self.topView.bottom - XJ_safeBottomMargin) collectionViewLayout:layout];
        //注册cell
        [_dragSortView registerClass:[XJDargSortCell class] forCellWithReuseIdentifier:@"XJDargSortCell"];
        _dragSortView.dataSource = self;
        _dragSortView.backgroundColor = [UIColor whiteColor];
    }
    return _dragSortView;
}

- (UICollectionView *)recommendCollectionView {
    
    if (!_recommendCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(FitValue(80), FitValue(36));
        layout.sectionInset = UIEdgeInsetsMake(FitValue(8), kContentLeftAndRightSpace, kContentLeftAndRightSpace, kContentLeftAndRightSpace);
        _recommendCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, XJ_ScreenWidth, XJ_ScreenHeight - self.topView.bottom - XJ_safeBottomMargin) collectionViewLayout:layout];
        //注册cell
        [_recommendCollectionView registerClass:[XJAddCell class] forCellWithReuseIdentifier:@"XJAddCell"];
        _recommendCollectionView.dataSource = self;
//        _recommendCollectionView.delegate = self;
        _recommendCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _recommendCollectionView;
}

@end

