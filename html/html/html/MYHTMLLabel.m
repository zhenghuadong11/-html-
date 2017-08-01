//
//  MYHTMLLabel.m
//  HTML排版
//
//  Created by apple on 17/4/13.
//  Copyright © 2017年 zhenghuadong. All rights reserved.
//

#import "MYHTMLLabel.h"

@implementation MYHTMLLabel
{
    UILabel * _label;  //这个用来计算文字的值
}

-(void)setText:(NSString *)text{
    if (self.width == 0 && self.height == 0) {
        if (_label == nil) {
            _label = [[UILabel alloc] init];
        }
        _text = text;
        _label.text = text;
        [_label sizeToFit];
        self.width = _label.width;
        self.height = _label.height;
    }
}
-(void)drawRect:(CGRect)rect{
    
    
    CGRect bounce = rect;
    bounce.origin = CGPointZero;
    if(self.text != nil){
        NSMutableDictionary * attribute = [NSMutableDictionary dictionary];
        if (_font != nil) {
            [attribute setObject:_font forKey:NSFontAttributeName];
        }
        if(_color != nil){
            [attribute setObject:_color forKey:NSForegroundColorAttributeName];
        }
        if(_attribute != nil){
            attribute = [[NSMutableDictionary alloc] initWithDictionary:_attribute];
        }
        
        [self.text drawInRect:bounce withAttributes:attribute];
    }
}

@end
