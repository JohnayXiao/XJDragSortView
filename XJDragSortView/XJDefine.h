//
//  XJDefine.h
//
//  Created by Johnay  on 2019/5/21.
//  Copyright © 2019 SZUI. All rights reserved.
//

#ifndef XJDefine_h
#define XJDefine_h

/***  当前屏幕宽度 */
#define XJ_ScreenWidth   [UIScreen mainScreen].bounds.size.width
/***  当前屏幕高度 */
#define XJ_ScreenHeight  [UIScreen mainScreen].bounds.size.height

#define  XJ_iPhoneX ((XJ_ScreenWidth == 375.f && XJ_ScreenHeight == 812.f || XJ_ScreenWidth == 414.f && XJ_ScreenHeight == 896.f) ? YES : NO)
#define XJ_NavigationBarHeight  (XJ_iPhoneX ? 88.f : 64.f)
#define XJ_TabbarHeight         (XJ_iPhoneX ? (49.f+34.f) : 49.f)
#define XJ_safeBottomMargin   (XJ_iPhoneX ? 34.f : 0.f)

/***  屏宽比例 */
#define FitValue(value) (((value)/375.0f*[UIScreen mainScreen].bounds.size.width))
#define kSubscribeHeight  FitValue(36)
#define kContentLeftAndRightSpace  FitValue(12)
#define kTopViewHeight  FitValue(80)
#define RGBCOLOR(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]




#endif /* XJDefine_h */
