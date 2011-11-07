
#import "BezelView.h"

@implementation BezelView {
    NSString *text_;
}


@synthesize text = text_;


- (void)drawRect:(NSRect)rect {
    NSColor *bgColor = [NSColor colorWithCalibratedWhite:0.0 alpha:0.35];
    NSRect bgRect = rect;
    int minX = NSMinX(bgRect);
    int midX = NSMidX(bgRect);
    int maxX = NSMaxX(bgRect);
    int minY = NSMinY(bgRect);
    int midY = NSMidY(bgRect);
    int maxY = NSMaxY(bgRect);
    float radius = 25.0; // correct value to duplicate Panther's App Switcher
    NSBezierPath *bgPath = [NSBezierPath bezierPath];
    
    // Bottom edge and bottom-right curve
    [bgPath moveToPoint:NSMakePoint(midX, minY)];
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(maxX, minY) 
                                     toPoint:NSMakePoint(maxX, midY) 
                                      radius:radius];
    
    // Right edge and top-right curve
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(maxX, maxY) 
                                     toPoint:NSMakePoint(midX, maxY) 
                                      radius:radius];
    
    // Top edge and top-left curve
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(minX, maxY) 
                                     toPoint:NSMakePoint(minX, midY) 
                                      radius:radius];
    
    // Left edge and bottom-left curve
    [bgPath appendBezierPathWithArcFromPoint:bgRect.origin 
                                     toPoint:NSMakePoint(midX, minY) 
                                      radius:radius];
    [bgPath closePath];
    
    [bgColor set];
    [bgPath fill];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[NSFont systemFontOfSize:125.0f] forKey:NSFontAttributeName];
    
    if (text_) {
        NSSize textSize = [text_ sizeWithAttributes:attributes];
        NSPoint textCenter = NSMakePoint((maxX / 2) - (textSize.width / 2), (maxY / 2) - (textSize.height / 2));
        
        [text_ drawAtPoint:textCenter withAttributes:attributes];    
    }
}


- (void)setText:(NSString *)text {
    if (text != text_) {
        [text_ release];
        text_ = [text copy];
        
        [self setNeedsDisplay:YES];
    }
}


@end
