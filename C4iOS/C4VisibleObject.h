//
//  C4VisualObject.h
//  C4iOS
//
//  Created by travis on 2013-10-31.
//  Copyright (c) 2013 Slant. All rights reserved.
//

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
