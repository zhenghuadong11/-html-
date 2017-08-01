//
//  MYHTMLLabel.h
//  HTML排版
//
//  Created by apple on 17/4/13.
//  Copyright © 2017年 zhenghuadong. All rights reserved.
//

#import "MYHTMLView.h"

@interface MYHTMLLabel : MYHTMLView
@property(nonatomic,copy) NSString * text;
@property(nonatomic,strong) UIFont * font;
@property(nonatomic,strong) UIColor * color;
@property(nonatomic,copy) NSDictionary * attribute;
@end
