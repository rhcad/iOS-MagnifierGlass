//
//  TouchReader.m
//  SimplerMaskTest
//  Modified by Zhang Yungui <https://github.com/rhcad/touchvg>
//

#import "TouchReader.h"
#import "MagnifierView.h"

@implementation TouchReader

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	// just create one loop and re-use it.
	if (loop == nil) {
		loop = [[MagnifierView alloc] init];
		loop.viewToMagnify = self;
        loop.followFinger = YES;
        [self.superview addSubview:loop];
	}
    
    // add the loop to the superview.  if we add it to the view it magnifies, it'll magnify itself!
    //[self.superview addSubview:loop];
	
	UITouch *touch = [touches anyObject];
	loop.touchPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	loop.touchPoint = [touch locationInView:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //[loop hide];
	//[loop removeFromSuperview];
}

- (void)dealloc {
	[loop release];
	loop = nil;
	[super dealloc];
}

@end
