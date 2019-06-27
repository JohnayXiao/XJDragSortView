//
//  XJAddCell.h
//
//  Created by Johnay  on 2019/5/21.
//  Copyright © 2019 SZUI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XJDragSortDelegate <NSObject>

- (void)XJAddCellAddSubscribe:(NSString *)subscribe;

@end

@interface XJAddCell : UICollectionViewCell
@property (nonatomic,strong) NSString * subscribe;
@property (nonatomic,weak) id<XJDragSortDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
