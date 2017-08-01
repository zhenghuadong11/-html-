//
//  MYHTMLView.m
//  HTML排版
//
//  Created by zhenghuadong on 17/3/26.
//  Copyright © 2017年 zhenghuadong. All rights reserved.
//

#import "MYHTMLView.h"

@interface MYHTMLView()
//只读属性
@property(nonatomic,assign)  float contentX; //流式排版到达的X值；
@property(nonatomic,assign)  float contentY;
@property(nonatomic,assign) float nextLineY;  //下一行的最大Y值；
@end

@implementation MYHTMLView
{

    
    __weak id _s;
    SEL _sel;
}
-(instancetype)init{
    if (self = [super init]) {
        self.htmlWidth = -1;
        self.htmlHeight = -1;
        self.top = noneMargin;
        self.left = noneMargin;
        self.right = noneMargin;
        self.bottom = noneMargin;
        
        self.positionType = PositionTypeRelative;
        self.positionH = PositionHNone;
        self.positionV = PositionVNone;
        self.isLine = true;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


+(instancetype)viewWithRelative{
    MYHTMLView * view = [[self alloc] init];
    view.positionType = PositionTypeRelative;
    return view;
}
+(instancetype)viewWithStatic{
    MYHTMLView * view = [[self alloc] init];
    view.positionType = PositionTypeStatic;
    return view;
}



-(void)addHTMlView:(MYHTMLView *)view{
    [self addSubview:view];
    [self layoutView:view];
}

-(void) layoutView:(MYHTMLView *) view{
    if (view.htmlWidth >= 0) {
        view.width = self.width * view.htmlWidth/100.0;
    }
    if (view.htmlHeight >= 0) {
        view.height = self.height * view.htmlHeight/100.0;
    }
    
    
    
    if (view.positionType == PositionTypeRelative) {
        [self relativeLayoutWithView:view];
    }else{
        [self staticLayoutWithView:view];
    }
}


-(void) staticLayoutWithView:(MYHTMLView *) view{
    if (view.isLine) {
        if (self.contentX + view.width  > self.width + 1) {
            [self nextLineWithView:view];
        }else{
            view.x = self.contentX;
            view.y = self.contentY;
            [self marginToView:view];
            
            self.contentX = view.maxX;
            self.nextLineY = self.nextLineY > view.maxY ? self.nextLineY : view.maxY;
        }
    }else{
        [self nextLineWithView:view];
    }
}
-(void) nextLineWithView:(MYHTMLView *) view{
    view.x = 0;
    view.y = self.nextLineY;
    [self marginToView:view];
    
    self.nextLineY = view.maxY;
    self.contentX = view.maxX;
    self.contentY = view.y;
}
-(void) marginToView:(MYHTMLView *) view{
    if (view.right != noneMargin) {
        view.x -= view.right;
    }
    if (view.bottom != noneMargin) {
        view.y -= view.bottom;
    }
    
    if (view.left != noneMargin) {
        view.x += view.left;
    }
    if (view.top != noneMargin) {
        view.y += view.top;
    }
}


-(void) relativeLayoutWithView:(MYHTMLView *) view{
    
    if (view.top != noneMargin && view.bottom != noneMargin&&view.left != noneMargin && view.right != noneMargin) {
        
        if (view.top + view.bottom < self.height) {
            view.height = self.height - view.top - view.bottom;
            view.y = view.top;
        }else{
            view.height = 0;
            view.y = view.top;
        }
        if (view.left + view.right < self.width) {
            view.width = self.width - view.left - view.right;
            view.x = view.left;
        }else{
            view.width = 0;
            view.x = view.left;
        }
        return;
    }
    
    
    if (view.top != noneMargin && view.bottom != noneMargin&&view.left != noneMargin) {
        view.x = view.left;
        if (view.top + view.bottom < self.height) {
            view.height = self.height - view.top - view.bottom;
            view.y = view.top;
        }else{
            view.height = 0;
            view.y = view.top;
        }
        return;
    }
    if (view.top != noneMargin && view.left != noneMargin && view.right != noneMargin) {
        view.y = view.top;
        if (view.left + view.right < self.width) {
            view.width = self.width - view.left - view.right;
            view.x = view.left;
        }else{
            view.width = 0;
            view.x = view.left;
        }
        return;
    }
    
    
    
    
    if (view.positionH == PositionHNone && view.positionV == PositionVNone) {
        if (view.right != noneMargin) {
            view.x = self.width - view.width - view.right;
        }
        if (view.bottom != noneMargin) {
            view.y = self.height - view.height - view.bottom;
        }
        
        if (view.left != noneMargin) {
            view.x = view.left;
        }
        if (view.top != noneMargin) {
            view.y = view.top;
        }
        if (view.top == noneMargin && view.bottom == noneMargin) {
            view.y = 0;
        }
        if (view.left == noneMargin && view.right == noneMargin) {
            view.x = 0;
        }
        return;
    }else{
        if (view.positionV == PositionTop) {
            view.y = 0;
        } else if (view.positionV == PositionBottom){
            view.y = self.height - view.height;
        }else if (view.positionV == PositionVCenter){
            view.y = (self.height - view.height)/2;
        }else{
            view.y = 0;
        }
        
        if (view.positionH == PositionLeft){
            view.x = 0;
        }else if (view.positionH == PositionRight){
            view.x = self.width - view.width;
        }else if (view.positionH == PositionHCenter){
            view.x = (self.width - view.width)/2;
        }else{
            view.x = 0;
        }
        
        if (view.right != noneMargin) {
            view.x -= view.right;
        }
        if (view.bottom != noneMargin) {
            view.y -= view.bottom;
        }
        
        if (view.left != noneMargin) {
            view.x += view.left;
        }
        if (view.top != noneMargin) {
            view.y += view.top;
        }
        
    }
    
    
}


-(void)layout{
    
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[MYHTMLView class]]) {
            [self layoutView:(MYHTMLView *)view];
            [(MYHTMLView *)view layout];
        }
   
    }
}



-(void)addTargit:(id)targit selector:(SEL)sel{
    _s = targit;
    _sel = sel;
 
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_s respondsToSelector:_sel]) {
        [_s performSelector:_sel withObject:self];
    }else{
        [super touchesBegan:touches withEvent:event];
    }
}


@end
