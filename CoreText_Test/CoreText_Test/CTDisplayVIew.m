//
//  CTDisplayVIew.m
//  CoreText_Test
//
//  Created by ZhijieLi on 15/2/13.
//  Copyright (c) 2015年 ZhijieLi. All rights reserved.
//

#import "CTDisplayVIew.h"
#import "CoreText/CoreText.h"

@implementation CTDisplayVIew

// 绘制函数
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    // 步骤1，得到当前绘画布的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 步骤2，将坐标系翻转，与UIKit统一【左上角（0，0）】
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 步骤3，创建绘画区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    
    // 步骤4，创建绘制内容
    NSAttributedString *attString = [[NSAttributedString alloc]initWithString:@"My Hello"];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    
    // 步骤5，显示
    CTFrameDraw(frame, context);
    
    // 步骤6，释放内存
    CFRelease(context);
    CFRelease(path);
    CFRelease(framesetter);
    
    NSLog(@"testing.......");
}

@end
