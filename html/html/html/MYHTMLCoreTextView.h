//
//  MYHTMLCoreTextView.h
//  HTML排版
//
//  Created by apple on 17/4/13.
//  Copyright © 2017年 zhenghuadong. All rights reserved.
//

#import "MYHTMLView.h"
@class MYHTMLCoreTextView;
@protocol MYHTMLCoreTextViewDelegate
-(void) coreTextView:(MYHTMLCoreTextView *) view clickURL:(NSString *)url;
@end
@interface MYHTMLCoreTextView : MYHTMLView

#define CONTENT @"content"

@property(nonatomic,copy) UIBezierPath * path;   //文本的范围

@property(nonatomic,copy) NSArray<NSAttributedString *> * attributeStrs;   //这个接口为每个字符串提供拓展参数处理：｛《link：点击代理返回地址。》｝

/**
   content:image/text
   
   when content == image
   width :宽度
   height : 高度
   url: 链接
   
   when content == text
   
    color： 颜色
    font : 字体
    url: 链接
 */

@property(nonatomic,copy) NSArray<NSDictionary *> * attributeJson;  //这个接口与aStr属性二取一；(暂未实现)
@property(nonatomic,strong) id<MYHTMLCoreTextViewDelegate> delegate;






//-(void) addSubViewToLayout:(UIView *)view;
-(void) hereSizeToFit;
@end
