//
//  CTViewB.m
//  CoreText_Test
//
//  Created by ZhijieLi on 15/2/17.
//  Copyright (c) 2015年 ZhijieLi. All rights reserved.
//

#import "CTViewB.h"
#import <CoreText/CoreText.h>

#define ASTTRSTR @"这是coreText测试，欢迎使用，哈哈哈.Feb 17 16:38:05 ZhijieLideMacBook-Pro.local CoreText_Test[2514] <Error>: CGContextResetState: invalid context 0x7c132c40. This is a serious error. This application, or a library it uses, is using an invalid context  and is thereby contributing to an overall degradation of system stability and reliability. This notice is a courtesy: please fix this problem. It will become a fatal error in an upcoming update."

@implementation CTViewB

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -
#pragma mark init

-(id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

#pragma mark drawRect

-(void)drawRect:(CGRect)rect{
    // 取得当前context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 翻转坐标系
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    // 创建内容
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:ASTTRSTR];
    
    // --- 字体
    UIFont *font = [UIFont systemFontOfSize:24];
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    [attributedStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, [attributedStr length])];
    CFRelease(fontRef);
    
    // --- 颜色
    [attributedStr addAttribute:(NSString *)kCTForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(1, 10)];
    
    // --- >>> 图片
    NSString *taobaoImgName = @"taobao.png";
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = RunDelegateDeallocCallback;
    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
    imageCallbacks.getWidth = RunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void*)taobaoImgName);
    NSMutableAttributedString *imgAttrStr = [[NSMutableAttributedString alloc]initWithString:@" "];
    //1
    [imgAttrStr addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];
    CFRelease(runDelegate);
    //2
    [imgAttrStr addAttribute:@"imgName" value:taobaoImgName range:NSMakeRange(0, 1)];
    [attributedStr insertAttributedString:imgAttrStr atIndex:4];
    
    
    // 创建画板
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedStr);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attributedStr length]), path, NULL);
    
    // 显示
    CTFrameDraw(frame, context);
    
    
    // 渲染图片
    CFArrayRef lines = CTFrameGetLines(frame);
    CGPoint lineOrigins[CFArrayGetCount(lines)]; // ??????
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);  // 行
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        
        // 获取line的属性
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);  // line 包含 run（共享属性集）
        
                for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigins[i];
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);  // 共享属性资源
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            CGRect runRect;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            
            runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
            
            NSString *imageName = [attributes objectForKey:@"imgName"];
            //图片渲染逻辑
            if (imageName) {
                UIImage *image = [UIImage imageNamed:imageName];
                if (image) {
                    CGRect imageDrawRect;
                    imageDrawRect.size = image.size;
                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
                    imageDrawRect.origin.y = lineOrigin.y;
                    
                    // Core Graphics 函数
                    CGContextDrawImage(context, imageDrawRect, image.CGImage);
                }
            }
        }
    }
    
    
    
    // 释放内存
    CFRelease(context);
    CFRelease(path);
    CFRelease(framesetter);
    
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark CTRunDelegateCallbacks

// Core Text 中使用 Core Graphics 渲染图片
void RunDelegateDeallocCallback( void* refCon ){
    
}

CGFloat RunDelegateGetAscentCallback( void *refCon ){
    NSString *imageName = (__bridge NSString *)refCon;
    return [UIImage imageNamed:imageName].size.height;
}

CGFloat RunDelegateGetDescentCallback(void *refCon){
    return 0;
}

CGFloat RunDelegateGetWidthCallback(void *refCon){
    NSString *imageName = (__bridge NSString *)refCon;
    return [UIImage imageNamed:imageName].size.width;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

@end
