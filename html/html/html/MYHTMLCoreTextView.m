
//
//  MYHTMLCoreTextView.m
//  HTML排版
//
//  Created by apple on 17/4/13.
//  Copyright © 2017年 zhenghuadong. All rights reserved.
//

#import "MYHTMLCoreTextView.h"
#import <CoreText/CoreText.h>

@implementation MYHTMLCoreTextView
{
    
    /*
     * 用来记录绘画的字符。可以从这里获取CTLine和CTRun
     */
    CTFrameRef _frameRef;
    
    
    /*
     *   记录代理的dict属性，让其不为空。
     */
    NSMutableArray <NSDictionary *>* _dicts;
    
    
    NSInteger _viewTag;  //被环绕的view的tag
    
    /*
     *  下边距和右边距，因为不知道怎么从CTRun中获取，缺少了字符和图片又显示不出来。所以这里加上。
     */
    CGFloat _bottomPad;
    CGFloat _rightPad;
    
    
    /*
     * 这个原计划用来代替tag记录，环绕的View，但是最后用了tag，那就算了。
     */
    NSMutableArray <UIView *> * _insertViews;
    NSMutableAttributedString * _attributeStr;
    
}
-(instancetype)init{
    if (self = [super init]) {
        _viewTag = 1000;
        _bottomPad = 0.1;
        _rightPad = 0.3;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _viewTag = 1000;
        _bottomPad = 0.1;
        _rightPad = 0.3;
    }
    return self;
}

-(void)setAttributeStrs:(NSArray<NSAttributedString *> *)attributeStrs{
    _attributeStrs = attributeStrs;
    [self setAttributeStr];
    [self setNeedsDisplay];
}

-(void) setAttributeStr{
   _attributeStr = [[NSMutableAttributedString alloc] init];
    _dicts = [NSMutableArray array];
    for(NSAttributedString * sonStr in _attributeStrs)
    {
        NSRange range;
        NSDictionary * attribute = [sonStr attributesAtIndex:0 effectiveRange:&range];
        
        if ([attribute[@"content"] isKindOfClass:[NSString class]]) {
            //不是图片的直接加入
            [_attributeStr appendAttributedString:sonStr];
        }else if([attribute[@"content"] isKindOfClass:[UIImage class]]){
            
            UIImage * image = attribute[@"content"];
            
            CGFloat width = image.size.width;
            CGFloat height = image.size.height;
            
            if (attribute[@"width"] != nil) {
                width = [attribute[@"width"] floatValue];
            }
            if (attribute[@"height"] != nil) {
                height = [attribute[@"height"] floatValue];
            }
            NSDictionary  * dict = @{@"height":@(height),@"width":@(width)};
            [_dicts addObject:dict];
            CTRunDelegateCallbacks callBacks;
            memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
            callBacks.version = kCTRunDelegateVersion1;
            callBacks.getAscent = ascentCallBacks;
            callBacks.getDescent = descentCallBacks;
            callBacks.getWidth = widthCallBacks;
            
            CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks, (__bridge void *)dict);
            unichar placeHolder = 0xFFFC;
            NSString * placeHolderStr = [NSString stringWithCharacters:&placeHolder length:1];
            
            
            NSMutableAttributedString * placeHolderAttrStr =  [[NSMutableAttributedString alloc] initWithString:placeHolderStr attributes:attribute];
            CFAttributedStringSetAttribute((CFMutableAttributedStringRef)placeHolderAttrStr, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
            
            CFRelease(delegate);
            [_attributeStr appendAttributedString:placeHolderAttrStr];
        }
    }
}



-(void)setPath:(UIBezierPath *)path{
    _path = path;
    [self setNeedsDisplay];
}




-(void)dealloc{
    CFRelease(_frameRef);
}



-(void)drawRect:(CGRect)rect
{
    
    
    
    
    
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_attributeStr);

    
    CGRect pathRect = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect));
    
    CGPathRef path = CGPathCreateWithRect(pathRect, nil);
    
    if (_frameRef != nil) {
        CFRelease(_frameRef);
    }
    _frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, _attributeStr.length), path, NULL);
    
    CTFrameDraw(_frameRef, context);
    
    NSArray<NSDictionary *> * images = [self imageAndFrameToDraw:_frameRef];
    
    
    for (NSDictionary * imageDic in images) {
        NSValue * frameValue = imageDic[@"frame"];
        CGRect frame = [frameValue CGRectValue];
        UIImage * image = imageDic[@"image"];
        [image drawInRect:frame];
    }
    
   

    if (frameSetter != nil) {
        CFRelease(frameSetter);
    }
   
    
    
}

-(NSArray<NSDictionary *> *) imageAndFrameToDraw:(CTFrameRef)frame{
    
    
    
    NSMutableArray * returnArr = [NSMutableArray array];
    
    NSArray * lines = (NSArray *)CTFrameGetLines(frame);
    NSInteger lineCount = lines.count;
    CGPoint point[lineCount];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), point);
    
    
    for (NSInteger i = 0; i < lineCount; i += 1) {
        CTLineRef line =(__bridge CTLineRef) lines[i];
        NSArray * runs = (NSArray *)CTLineGetGlyphRuns(line);
        for (NSInteger j = 0; j < runs.count; j += 1) {
            CTRunRef run = (__bridge CTRunRef)runs[j];
            NSDictionary * dict =  (__bridge NSDictionary *)CTRunGetAttributes(run);
            
           
            
            if ([dict[@"content"] isKindOfClass: [UIImage class]]) {
                
                
                CGFloat ascent;
                CGFloat descent;
                CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
                CGFloat height = ascent + descent;
                CGFloat x = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                CGFloat y = point[i].y;
                
                NSValue * value = [NSValue valueWithCGRect:CGRectMake(x, y, width, height)];
                NSDictionary * imageDict = @{@"image":dict[@"content"],@"frame":value};
                [returnArr addObject:imageDict];
            }
            
        }
    }
    
    
    
    return returnArr;
}


-(CGRect) reallyRect:(CGRect) rect{
    if (rect.origin.y + rect.size.height > self.bounds.size.height) {
        rect.size.height = self.bounds.size.height - rect.origin.y;
    }
    CGFloat y = self.bounds.size.height - (rect.origin.y + rect.size.height);
    rect.origin.y = y;
    return  rect;
}
-(CGFloat) reallyY:(CGFloat) y{
    return self.bounds.size.height - y;
}

static CGFloat ascentCallBacks(void * ref)
{
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"height"] floatValue];
}
static CGFloat descentCallBacks(void * ref)
{
    return 0;
}
static CGFloat widthCallBacks(void * ref)
{
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"width"] floatValue];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint touchPoint = [touches.anyObject locationInView:self];
    
    NSArray * lines = (NSArray *)CTFrameGetLines(_frameRef);
    
    NSInteger count = [lines count];
    /*
     * 这个y坐标是基线的位置
     */
    CGPoint points[count];
    CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, 0), points);
    
    
    
    NSInteger i = 0;
    // 获取点击行的下一行
    for (; i < lines.count; i += 1) {
        
        NSLog(@"line point %f %f",[self reallyY:points[i].y],touchPoint.y);
        if ([self reallyY:points[i].y]> touchPoint.y) {
            break;
        }
    }
    if (i == lines.count) {
        return;
    }
    
    CTLineRef line = (__bridge CTLineRef)lines[i];
    NSArray * runs = (NSArray *) CTLineGetGlyphRuns(line);
    i = 0;
    //计算点击run的下一个run
    for(; i<runs.count; i+=1){
        
        CTRunRef run = (__bridge CTRunRef)runs[i];
        
        
        CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
        CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), NULL, NULL, NULL);
   
        if (xOffset + width > touchPoint.x) {
            break;
        }
    }
    if (i == runs.count) {
        return;
    }

    CTRunRef run = (__bridge CTRunRef)runs[i];
    
    NSDictionary * attributes = (NSDictionary *)CTRunGetAttributes(run);
    
    NSLog(@"%@",attributes);
    
    if(attributes == nil || attributes[NSLinkAttributeName] == nil){
        return;
    }
    [self.delegate coreTextView:self clickURL:attributes[NSLinkAttributeName]];
}

-(void)hereSizeToFit{
    
    [self setCTFrame];
    NSArray * lines = (NSArray *)CTFrameGetLines(_frameRef);
    CTLineRef line = (__bridge CTLineRef)lines.lastObject;
    CGPoint points[lines.count];
    
    CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, 0), points);
    CGRect rect1 = self.frame;
    
    CGFloat ascent;
    
    CGFloat descent;
    CGFloat leading;
    
    CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    NSLog(@"---width --- %f",width);
    
    /*
     * 这个y坐标是基线的位置
     */
    CGPoint point = points[lines.count - 1];
    
   
  //  [self reallyY:point.y] + (ascent - (NSInteger)ascent) + descent + leading+ _bottomPad
    rect1.size.height = rect1.size.height - point.y + (ascent - (NSInteger)ascent) + descent + leading+ _bottomPad;
    
    
    NSLog(@"height -- rect1,%f",rect1.size.height);
    
    
    self.frame = rect1;
    if (lines.count <=1) {
        
        
        NSArray * array = (NSArray *)CTLineGetGlyphRuns(line);
        CTRunRef run =  (__bridge CTRunRef)array.lastObject;
        CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
        CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), NULL, NULL, NULL);
#pragma mark 这里还差一个像素，因为英文还有右边距，中文就没有，这里就不管了，统一加一个像素
        CGRect rect2 = self.frame;
        rect2.size.width = xOffset + width + _rightPad;
        NSLog(@"--width2--%f",rect2.size.width);
        self.frame = rect2;
    }
}
-(void) setCTFrame{
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_attributeStr);
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    if (width == 0) {
        width = 10000;
        height = 10000;
    }else if(height == 0){
        height = 10000;
    }
    self.width = width;
    self.height = height;
    
    CGRect pathRect = CGRectMake(0, 0, width, height);
    
    CGPathRef path = CGPathCreateWithRect(pathRect, nil);
    
    if (_frameRef != nil) {
        CFRelease(_frameRef);
    }
    _frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, _attributeStr.length), path, NULL);

    
    if (frameSetter != nil) {
        CFRelease(frameSetter);
    }

}


-(void)setAttributeJson:(NSArray<NSDictionary *> *)attributeJson{
    NSMutableArray * array = [NSMutableArray array];
    
    for (NSDictionary * attribute in attributeJson) {
        NSAttributedString * str;
        if ([attribute[@"content"] isKindOfClass:[UIImage class]]) {
            str = [[NSAttributedString alloc] initWithString:@" " attributes:attribute];
            
        }else{
            str = [[NSAttributedString alloc] initWithString:attribute[@"content"] attributes:attribute];
        }
        [array addObject:str];
    }
    self.attributeStrs = array;
}




@end
