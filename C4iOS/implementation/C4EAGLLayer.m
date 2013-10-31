//
//  C4EAGLLayer.m
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


#import "C4EAGLLayer.h"

/*
 The C4LayerAnimation protocol requires some private properties
 Here, we list the private properties.
 These need to be manually copied into each new class that conforms to C4LayerAnimation.
 It's a pain, but this small conformance allows for a significantly lighter code-base.
 */
@interface C4EAGLLayer ()
@property (nonatomic) CGFloat rotationAngle, rotationAngleX, rotationAngleY;
@end

@implementation C4EAGLLayer
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
        self.name = @"eaglLayer";
        self.repeatCount = 0;
        self.autoreverses = NO;
        self.masksToBounds = NO;
        
        _currentAnimationEasing = (NSString *)kCAMediaTimingFunctionEaseInEaseOut;
        _allowsInteraction = NO;
        _repeats = NO;
    }
    return self;
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
