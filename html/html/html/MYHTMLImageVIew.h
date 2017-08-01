//
//  MYHTMLImageVIew.h
//  HTML排版
//
//  Created by apple on 17/4/13.
//  Copyright © 2017年 zhenghuadong. All rights reserved.
//

#import "MYHTMLView.h"

@interface MYHTMLImageVIew : MYHTMLView
@property(nonatomic,strong) UIImage * image;
/**表示是否图片变灰
 */
@property(nonatomic,assign) BOOL isGray;
@end
