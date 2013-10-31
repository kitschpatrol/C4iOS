//
//  C4ShapeLayer.m
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

#import "C4ShapeLayer.h"

/*
 The C4LayerAnimation protocol requires some private properties
 Here, we list the private properties.
 These need to be manually copied into each new class that conforms to C4LayerAnimation.
 It's a pain, but this small conformance allows for a significantly lighter code-base.
 */
@interface C4ShapeLayer()
@property (nonatomic) CGFloat rotationAngle, rotationAngleX, rotationAngleY;
@end

@implementation C4ShapeLayer
+(void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method copy;
        Method local;
        //LAYER ANIMATION
        //grabs a class method from C4LayerAnimationImp
        //method being copied contains boilerplate code
        //for copying all other protocol methods
        copy = class_getClassMethod([C4LayerAnimationImp class], @selector(copyMethods));
        
        //local method into which we will set the implementation of "copy"
        local = class_getClassMethod([self class], @selector(copyMethods));
        
        //sets the implementation of "local" with that of "copy"
        method_setImplementation(local, method_getImplementation(copy));
        
        //implements, at a class level, the copy method for this class
        [[self class] copyMethods];

    });
}

+(void)copyMethods{}

-(id)init {
    self = [super init];
    if(self != nil) {
        self.name = @"shapeLayer";
        _animationDuration = 0.0f;
        _currentAnimationEasing = [[NSString alloc] init];
        _currentAnimationEasing = (NSString *)kCAMediaTimingFunctionEaseInEaseOut;
        _allowsInteraction = NO;
        _repeats = NO;
        
        /* create basic attributes after setting animation attributes above */
        CGPathRef newPath = CGPathCreateWithRect(CGRectZero, nil);
        self.path = newPath;
        [self setActions:@{@"animateRotation":[NSNull null]}];
        
        /* makes sure there are no extraneous animation keys lingering about after init */
        [self removeAllAnimations];
        CFRelease(newPath);
    }
    return self;
}

-(void)dealloc {
    [self removeAllAnimations];
}

#pragma mark ShapeLayer Methods
/* encapsulating an animation that will correspond to the superview's animation */
-(void)animatePath:(CGPathRef)path {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.path = path;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"path"];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.path = path;
            [self removeAnimationForKey:@"path"];
        }];
    }
    animation.fromValue = (id)self.path;
    animation.toValue = (__bridge id)path;
    [self addAnimation:animation forKey:@"animatePath"];
    [CATransaction commit];
}

-(void)animateFillColor:(CGColorRef)fillColor {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.fillColor = fillColor;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"fillColor"];
    
    animation.fromValue = (id)self.fillColor;
    animation.toValue = (__bridge id)fillColor;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.fillColor = fillColor;
            [self removeAnimationForKey:@"fillColor"];
        }];
    }
    [self addAnimation:animation forKey:@"animateFillColor"];
    [CATransaction commit];
}

-(void)animateLineDashPhase:(CGFloat)lineDashPhase {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.lineDashPhase = lineDashPhase;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"lineDashPhase"];
    animation.fromValue = @(self.lineDashPhase);
    animation.toValue = @(lineDashPhase);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.lineDashPhase = lineDashPhase;
            [self removeAnimationForKey:@"lineDashPhase"];
        }];
    }
    [self addAnimation:animation forKey:@"animateLineDashPhase"];
    [CATransaction commit];
}

-(void)animateLineWidth:(CGFloat)lineWidth {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.lineWidth = lineWidth;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"lineWidth"];
    animation.fromValue = @(self.lineWidth);
    animation.toValue = @(lineWidth);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.lineWidth = lineWidth;
            [self removeAnimationForKey:@"lineWidth"];
        }];
    }
    [self addAnimation:animation forKey:@"animateLineWidth"];
    [CATransaction commit];
}

-(void)animateMiterLimit:(CGFloat)miterLimit {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.miterLimit = miterLimit;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"miterLimit"];
    animation.fromValue = @(self.miterLimit);
    animation.toValue = @(miterLimit);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.miterLimit = miterLimit;
            [self removeAnimationForKey:@"miterLimit"];
        }];
    }
    [self addAnimation:animation forKey:@"animateMiterLimit"];
    [CATransaction commit];
}

-(void)animateStrokeColor:(CGColorRef)strokeColor {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.strokeColor = strokeColor;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeColor"];
    animation.fromValue = (id)self.strokeColor;
    animation.toValue = (__bridge id)strokeColor;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.strokeColor = strokeColor;
            [self removeAnimationForKey:@"strokeColor"];
        }];
    }
    
    [self addAnimation:animation forKey:@"animateStrokeColor"];
    [CATransaction commit];
}

-(void)animateStrokeEnd:(CGFloat)strokeEnd {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.strokeEnd = strokeEnd;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(self.strokeEnd);
    animation.toValue = @(strokeEnd);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.strokeEnd = strokeEnd;
            [self removeAnimationForKey:@"strokeEnd"];
        }];
    }
    [self addAnimation:animation forKey:@"animateStrokeEnd"];
    [CATransaction commit];
}

-(void)animateStrokeStart:(CGFloat)strokeStart {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.strokeStart = strokeStart;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeStart"];
    animation.fromValue = @(self.strokeStart);
    animation.toValue = @(strokeStart);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.strokeStart = strokeStart;
            [self removeAnimationForKey:@"strokeStart"];
        }];
    }
    [self addAnimation:animation forKey:@"animateStrokeStart"];
    [CATransaction commit];
}

#pragma mark Blocked Methods

-(void)setContentsGravity:(NSString *)contentsGravity {
    contentsGravity = contentsGravity;
    C4Log(@"C4ShapeLayer setContentsGravity not currently available");
}

-(void)setHidden:(BOOL)hidden {
    hidden = hidden;
    C4Log(@"C4ShapeLayer setHidden not currently available");
}

-(void)setDoubleSided:(BOOL)doubleSided {
    doubleSided = doubleSided;
    C4Log(@"C4ShapeLayer setDoubleSided not currently available");
}

-(void)setMinificationFilter:(NSString *)minificationFilter {
    minificationFilter = minificationFilter;
    C4Log(@"C4ShapeLayer setMinificationFilter not currently available");
}

-(void)setMinificationFilterBias:(float)minificationFilterBias {
    minificationFilterBias = minificationFilterBias;
    C4Log(@"C4ShapeLayer setMinificationFilterBias not currently available");
}

#pragma mark C4Layer Animation Methods
/*
 The C4LayerAnimation protocol requires the synthesis of some public properties.
 Here we list the private properties that need to be synthesized.
 These synths need to be manually copied into each class that conforms to C4LayerAnimation.
 It's a pain, but this small conformance allows for a significantly lighter code-base.
 */
@synthesize animationOptions = _animationOptions, currentAnimationEasing = _currentAnimationEasing,
repeatCount = _repeatCount, animationDuration = _animationDuration,
allowsInteraction = _allowsInteraction, repeats = _repeats;
@synthesize perspectiveDistance = _perspectiveDistance;

-(CABasicAnimation *)setupBasicAnimationWithKeyPath:(NSString *)keyPath { return  nil; }

-(CGFloat)animationDuration { return 0.0f; }

-(void)setAnimationOptions:(NSUInteger)animationOptions {}

-(void)setPerspectiveDistance:(CGFloat)perspectiveDistance {}

-(void)animateBackgroundColor:(CGColorRef)_backgroundColor {}

-(void)animateBorderColor:(CGColorRef)_borderColor {}

-(void)animateBackgroundFilters:(NSArray *)_backgroundFilters {}

-(void)animateBorderWidth:(CGFloat)_borderWidth {}

-(void)animateCompositingFilter:(id)_compositingFilter {}

-(void)animateContents:(CGImageRef)_image {}

-(void)animateCornerRadius:(CGFloat)_cornerRadius {}

-(void)animateLayerTransform:(CATransform3D)newTransform {}

-(void)animateRotation:(CGFloat)newRotationAngle {}

-(void)animateRotationX:(CGFloat)newRotationAngle {}

-(void)animateRotationY:(CGFloat)newRotationAngle {}

-(void)animateShadowColor:(CGColorRef)_shadowColor {}

-(void)animateShadowOffset:(CGSize)_shadowOffset {}

-(void)animateShadowOpacity:(CGFloat)_shadowOpacity {}

-(void)animateShadowPath:(CGPathRef)_shadowPath {}

-(void)animateShadowRadius:(CGFloat)_shadowRadius {}

-(void)animateZPosition:(CGFloat)_zPosition {}

@end
