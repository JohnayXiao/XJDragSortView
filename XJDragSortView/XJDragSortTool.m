//
//  XJDragSortTool.m
//   
//
//  Created by Johnay  on 2019/5/21.
//  Copyright © 2019 SZUI. All rights reserved.
//

#import "XJDragSortTool.h"

@implementation XJDragSortTool
static XJDragSortTool *DragSortTool = nil;

+ (instancetype)shareInstance
{
    @synchronized (self) {
        if (DragSortTool == nil) {
            DragSortTool = [[self alloc] init];
        }
    }
    
    return DragSortTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        if (DragSortTool == nil) {
            DragSortTool = [super allocWithZone:zone];
        }
    }
    return DragSortTool;
}

- (id)copy
{
    return DragSortTool;
}

- (id)mutableCopy{
    return DragSortTool;
}




@end
