//
//  JYSupportView.h
//  SeptEsayCam
//
//  Created by Sept on 16/4/5.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYSupportViewDelegate <NSObject>

@optional
- (void)pushEsaycamWebView;

@end

@interface JYSupportView : UIView

@property (weak, nonatomic) id<JYSupportViewDelegate>delegate;

@end
