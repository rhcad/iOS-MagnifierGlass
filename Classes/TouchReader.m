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
	}
    [loop show];
	
	UITouch *touch = [touches anyObject];
	loop.touchPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	loop.touchPoint = [touch locationInView:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [loop hide];
}

- (void)dealloc {
	[loop release];
	[super dealloc];
}

@end
