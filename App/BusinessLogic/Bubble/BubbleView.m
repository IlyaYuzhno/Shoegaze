//
//  BubbleView.m
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 09.02.2021.
//

#import "BubbleView.h"

@implementation BubbleView


- (void)drawRect:(CGRect)rect {
   
    // General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Rectangle Drawing
    CGContextSaveGState(context);
    CGContextSetBlendMode(context, kCGBlendModeLuminosity);
    CGContextBeginTransparencyLayer(context, NULL);

    CGRect rectangleRect = CGRectMake(1, 1, 260, 146);
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: rectangleRect byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: CGSizeMake(30, 30)];
    [rectanglePath closePath];
    [UIColor.lightGrayColor setStroke];
    rectanglePath.lineWidth = 4;
    rectanglePath.lineCapStyle = kCGLineCapRound;
    rectanglePath.lineJoinStyle = kCGLineJoinRound;
    [rectanglePath setLineDash: (CGFloat[]){6, 7} count: 2 phase: 0];
    [rectanglePath stroke];
    {
        NSString* textContent = @"DOUBLE TAP ON TRACK NAME TO SAVE IN FAVORITES";
        CGRect rectangleInset = CGRectInset(rectangleRect, 10, 0);
        NSMutableParagraphStyle* rectangleStyle = [[NSMutableParagraphStyle alloc] init];
        rectangleStyle.alignment = NSTextAlignmentLeft;
        NSDictionary* rectangleFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 27], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: rectangleStyle};

        CGFloat rectangleTextHeight = [textContent boundingRectWithSize: CGSizeMake(rectangleInset.size.width, INFINITY) options: NSStringDrawingUsesLineFragmentOrigin attributes: rectangleFontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, rectangleInset);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(rectangleInset), CGRectGetMinY(rectangleInset) + (rectangleInset.size.height - rectangleTextHeight) / 2, rectangleInset.size.width, rectangleTextHeight) withAttributes: rectangleFontAttributes];
        CGContextRestoreGState(context);
    }

    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);

    
}


@end
