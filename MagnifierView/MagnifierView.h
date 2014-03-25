//  MagnifierView.h
//

#import <UIKit/UIKit.h>

@interface MagnifierView : UIView {
    CGFloat _topMargin;
}

@property (nonatomic, assign) UIView *viewToMagnify;
@property (nonatomic) CGPoint touchPoint;
@property (nonatomic) BOOL followFinger;
@property (nonatomic) CGFloat scale;

- (void)show;
- (void)hide;

@end
