//
//  JYDefine.h
//  Esaycamera
//
//  Created by Sept on 16/4/6.
//  Copyright © 2016年 九月. All rights reserved.
//

#ifndef JYDefine_h
#define JYDefine_h

// 蓝牙
#define SERVICE_UUID     0xFFE0    // 服务ID
#define CHAR_UUID        0xFFE1    // 特征ID
#define  num_scale 10000.0         // 缩小倍率

// mainCtl
#define BOTTOM_PREVIEW_X 200
#define SHOW_Y (screenH - 30) * 0.5
#define QUICK_BUTTON_SIZE 40.0f
#define SLIDER_BTN_ADD_OR_MINSU  0.3
#define slider_view_hidden_time  4.0

#define setFont(r) [UIFont systemFontOfSize:(r)]

#define AnimationTime 100.0

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

// 颜色设置
#define setColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define setFont(r) [UIFont systemFontOfSize:(r)]
#define setBoldFont(r) [UIFont boldSystemFontOfSize:(r)]

/** 控件宽度 */
#define JYCortrolWidth 50
/** 间隙宽度 */
#define JYSpaceWidth 10

/** 背景透明度 */
#define BG_ALPHA 0.3

/** view的背景颜色 */
#define VIEW_ALPHA 0.3

#define SHOW_Y (screenH - 30) * 0.5

#define path_encode [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"Peripheral.ssb"]

// 手轮方向
#define BlueDerection @"derection"


#endif /* JYDefine_h */
