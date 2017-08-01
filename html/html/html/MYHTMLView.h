//
//  MYHTMLView.h
//  HTML排版
//
//  Created by zhenghuadong on 17/3/26.
//  Copyright © 2017年 zhenghuadong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+FRAME_SET.h"
@interface MYHTMLView : UIView

enum PositionType{
    /*
     流式布局，只对top，left，right，bottom属性负责
     */
    PositionTypeStatic,
    PositionTypeRelative   //绝对布局,脱离文档流，对所有属性负责
};

enum PositionH{
    PositionLeft,
    PositionRight,
    PositionHCenter,
    PositionCenter,
    PositionHNone
};
enum PositionV{
    PositionTop,
    PositionBottom,
    PositionVCenter,
    PositionVNone
};

typedef enum PositionH PositionH;
typedef enum PositionV PositionV;
typedef enum PositionType PositionType;

#define noneMargin (-10000)

@property(nonatomic,assign) float htmlWidth;  // 单位%  优先级比width高 -1表示不使用
@property(nonatomic,assign) float htmlHeight; //%

@property(nonatomic,assign) float top;    //noneMargin表示不使用，如果上下左右都有，那么优先级最高，如果，只有比width，和height高。
@property(nonatomic,assign) float left;
@property(nonatomic,assign) float right;
@property(nonatomic,assign) float bottom;

@property(nonatomic,assign) PositionH positionH;
@property(nonatomic,assign) PositionV positionV;


@property(nonatomic,assign) PositionType positionType;

@property(nonatomic,assign) BOOL isLine;  //是否和兄弟节点在同一行




+(instancetype) viewWithRelative;
+(instancetype) viewWithStatic;

-(void) addHTMlView:(UIView *) view;
-(void) layout;
-(void) addTargit:(id) targit selector:(SEL) sel;

@end
