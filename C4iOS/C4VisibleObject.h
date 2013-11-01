//
//  C4VisualObject.h
//  C4iOS
//
//  Copyright © 2010-2013 Travis Kirton
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//  and associated documentation files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
//  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import <Foundation/Foundation.h>

@class C4Control;

@protocol C4VisibleObject <NSObject>
#pragma mark - Convenience Methods
-(void)setup;
-(void)test;

#pragma mark Animation Properties
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) CGFloat animationDelay;
@property (nonatomic) NSUInteger animationOptions;
@property (nonatomic) CGFloat repeatCount;

#pragma mark Shadow Properties
@property (nonatomic) CGFloat shadowRadius;
@property (nonatomic) CGFloat shadowOpacity;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) CGPathRef shadowPath;

#pragma mark Other Properties
@property (nonatomic) BOOL masksToBounds;
@property (nonatomic) CATransform3D layerTransform;
@property (nonatomic, assign) C4Control *mask;
@property (nonatomic) CGPoint origin;
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) CGSize size;

#pragma mark Style Properties
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat zPosition;
@property (nonatomic) CGFloat rotation;
@property (nonatomic) CGFloat rotationX;
@property (nonatomic) CGFloat rotationY;
@property (nonatomic) CGFloat perspectiveDistance;
@property (nonatomic) CGPoint anchorPoint;
@property (nonatomic, weak) UIColor *borderColor;
@property (nonatomic) NSDictionary *style;

#pragma mark - other
-(void)renderInContext:(CGContextRef)context;

//#pragma mark - Default Style
//+(instancetype)defaultStyle;

+(void)copyMethods;
@end
