//
//   XJDargSortCell.h
//   
//
//  Created by Johnay  on 2019/5/21.
//  Copyright © 2019 SZUI. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SKDragSortDelegate <NSObject>

- (void)XJDargSortCellGestureAction:(UIGestureRecognizer *)gestureRecognizer;

- (void)XJDargSortCellCancelSubscribe:(NSString *)subscribe;

@end

@interface XJDargSortCell : UICollectionViewCell
@property (nonatomic,strong) NSString * subscribe;
@property (nonatomic,weak) id<SKDragSortDelegate> delegate;

- (void)showDeleteBtn;
@end

