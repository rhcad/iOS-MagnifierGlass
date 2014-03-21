//  MagnifierView.m
//  Fix CTM by Zhang Yungui <https://github.com/rhcad/touchvg> based on SimplerMaskTest:
//  http://stackoverflow.com/questions/13330975/how-to-add-a-magnifier-to-custom-control
//

#import "MagnifierView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MagnifierView
@synthesize viewToMagnify, touchPoint, followFinger, scale;

- (id)initWithFrame:(CGRect)frame {
    CGFloat w = 118;    // =imageWidth:126-(outerRadius:3 + 1)*2
	if (self = [super initWithFrame:CGRectMake(0, 0, w, w)]) {
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 3;
		self.layer.cornerRadius = w / 2;
		self.layer.masksToBounds = YES;
        self.opaque = NO;
        self.scale = 1.5f;
	}
	return self;
}

- (void)setTouchPoint:(CGPoint)pt {
	touchPoint = pt;
    [self setNeedsDisplay];
    
    if (self.alpha < 0.5f) {
        [self performSelector:@selector(show) withObject:nil afterDelay:0.5];
    } else {
        [self show];
    }
}

- (void)show {
    CGPoint pt = [self calcCenter];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.alpha < 0.5f || !CGPointEqualToPoint(self.center, pt)) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:0.2];
        self.alpha = 1;
        self.center = pt;
        [UIView commitAnimations];
    }
}

- (void)hide {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.2];
    self.alpha = 0;
    [UIView commitAnimations];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef mask = [UIImage imageNamed: @"loupe-shadow-mask.png"].CGImage;
    UIImage *glass = [UIImage imageNamed: @"loupe-shadow-hi.png"];
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, self.bounds, mask);
    
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextFillRect(context, self.bounds);
    
    CGContextTranslateCTM(context, self.frame.size.width / 2, self.frame.size.height / 2);
    CGContextScaleCTM(context, self.scale, self.scale);
    CGContextTranslateCTM(context, -touchPoint.x, -touchPoint.y);
    [self.viewToMagnify.layer renderInContext:context];
    
    CGContextRestoreGState(context);
    [glass drawInRect:self.bounds];
}

- (float)distanceBetween:(CGPoint)p1 and:(CGPoint)p2 {
    return sqrtf(powf(p2.x-p1.x, 2) + powf(p2.y-p1.y, 2));
}

- (CGPoint)calcCenter {
    if (self.followFinger) {
        return CGPointMake(touchPoint.x, touchPoint.y - 80);
    }
    
    if (_topMargin < 1) {
        UIViewController *controller = (UIViewController *)self.viewToMagnify.nextResponder;
        
        if ([controller isKindOfClass:[UIViewController class]]) {
            UINavigationBar *bar = controller.navigationController.navigationBar;
            CGRect rect = [bar convertRect:bar.bounds toView:self.viewToMagnify];
            _topMargin = CGRectGetMaxY(rect);
        }
        _topMargin++;
    }
    
    CGFloat margin = self.frame.size.width / 2 + 5;
    CGRect rect = CGRectInset(self.viewToMagnify.bounds, margin, margin + _topMargin);
    CGPoint pt = [self.superview convertPoint:self.center toView:self.viewToMagnify];
    
    if (!CGRectContainsPoint(CGRectInset(rect, -1, -1), pt)) {
        pt = rect.origin;
    }
    
    CGFloat dist = [self distanceBetween:pt and:touchPoint];
    
    if (dist < margin + 20) {
        if (pt.x < CGRectGetMidX(rect)) {
            pt.x = CGRectGetMaxX(rect);
            if ([self distanceBetween:pt and:touchPoint] < dist) {
                pt.x = CGRectGetMinX(rect);
            }
        }
        else {
            pt.x = CGRectGetMinX(rect);
            if ([self distanceBetween:pt and:touchPoint] < dist) {
                pt.x = CGRectGetMaxX(rect);
            }
        }
    }
    
    return [self.superview convertPoint:pt fromView:self.viewToMagnify];
}

@end