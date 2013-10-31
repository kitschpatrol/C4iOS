//
//  C4Control.m
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

#import "C4Control.h"

@interface C4Control()
@property (nonatomic) BOOL shouldAutoreverse;
@property (nonatomic, strong) NSString *longPressMethodName;
@property (nonatomic, strong) NSMutableDictionary *gestureDictionary;
@property (nonatomic, readonly) NSArray *stylePropertyNames;
@property (nonatomic) CGPoint firstPositionForMove;
@end

@implementation C4Control

+(void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method copy;
        Method local;
        //METHOD DELAY
        //grabs a class method from C4AddSubviewIMP
        //method being copied contains boilerplate code
        //for copying all other protocol methods
        copy = class_getClassMethod([C4MethodDelayIMP class], @selector(copyMethods));
        
        //local method into which we will set the implementation of "copy"
        local = class_getClassMethod([self class], @selector(copyMethods));
        
        //sets the implementation of "local" with that of "copy"
        method_setImplementation(local, method_getImplementation(copy));
        
        //implements, at a class level, the copy method for this class
        [[self class] copyMethods];

        //GESTURE
        //grabs a class method from C4AddSubviewIMP
        //method being copied contains boilerplate code
        //for copying all other protocol methods
        copy = class_getClassMethod([C4GestureIMP class], @selector(copyMethods));
        
        //local method into which we will set the implementation of "copy"
        local = class_getClassMethod([self class], @selector(copyMethods));
        
        //sets the implementation of "local" with that of "copy"
        method_setImplementation(local, method_getImplementation(copy));
        
        //implements, at a class level, the copy method for this class
        [[self class] copyMethods];

        //NOTIFICATION
        //grabs a class method from C4AddSubviewIMP
        //method being copied contains boilerplate code
        //for copying all other protocol methods
        copy = class_getClassMethod([C4NotificationIMP class], @selector(copyMethods));
        
        //local method into which we will set the implementation of "copy"
        local = class_getClassMethod([self class], @selector(copyMethods));
        
        //sets the implementation of "local" with that of "copy"
        method_setImplementation(local, method_getImplementation(copy));
        
        //implements, at a class level, the copy method for this class
        [[self class] copyMethods];

        //grabs a class method from C4AddSubviewIMP
        //method being copied contains boilerplate code
        //for copying all other protocol methods
        copy = class_getClassMethod([C4AddSubviewIMP class], @selector(copyMethods));
        
        //local method into which we will set the implementation of "copy"
        local = class_getClassMethod([self class], @selector(copyMethods));
        
        //sets the implementation of "local" with that of "copy"
        method_setImplementation(local, method_getImplementation(copy));
        
        //implements, at a class level, the copy method for this class
        [[self class] copyMethods];
    });
}

-(id)init {
    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {

        self.longPressMethodName = @"pressedLong";
        self.shouldAutoreverse = NO;

        self.style = [C4Control defaultStyle].style;
    }
    return self;
}

-(void)dealloc {
    [[NSRunLoop mainRunLoop] cancelPerformSelectorsWithTarget:self];
    self.backgroundColor = nil;
    self.longPressMethodName = nil;
    NSEnumerator *enumerator = [self.gestureDictionary keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        UIGestureRecognizer *g = (self.gestureDictionary)[key];
        [g removeTarget:self action:nil];
        [self removeGestureRecognizer:g];
    }
    [self.gestureDictionary removeAllObjects];
    self.gestureDictionary = nil;
}

-(void)setup {}

-(void)test {
    C4Log(@"test (%@)", [self class]);
}

#pragma mark UIView animatable property overrides

-(void)setCenter:(CGPoint)center {
    if(_animationDuration == 0.0f) super.center = center;
    else {
        CGPoint oldCenter = CGPointMake(self.center.x, self.center.y);
        
        void (^animationBlock) (void) = ^ { super.center = center; };
        void (^completionBlock) (BOOL) = nil;
        
        BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
        if(self.shouldAutoreverse && animationShouldNotRepeat) {
            completionBlock = ^ (BOOL animationIsComplete) {
                if(animationIsComplete){}
                [self autoreverseAnimation:^ { super.center = oldCenter;}];
            };
        }
        [self animateWithBlock:animationBlock completion:completionBlock];
    }
}

/*
 Had this in before, but took it out when I was fixing center position issues with labels and shapes
 There was a bug with this implementation that was sometimes switching the position base on landscape orientation
 */
//- (CGPoint)center {
//    CGPoint currentCenter = super.center;
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
//        currentCenter.x = super.center.y;
//        currentCenter.y = super.center.x;
//    }
//    return currentCenter;
//}

-(CGPoint)origin {
    return self.frame.origin;
}

-(void)setOrigin:(CGPoint)origin {
    CGPoint difference = origin;
    difference.x += self.frame.size.width/2.0f;
    difference.y += self.frame.size.height/2.0f;
    self.center = difference;
}

-(void)setFrame:(CGRect)frame {
    if(_animationDuration == 0.0f) super.frame = frame;
    else {
        CGRect oldFrame = self.frame;
        
        void (^animationBlock) (void) = ^ { super.frame = frame; };
        void (^completionBlock) (BOOL) = nil;
        
        BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
        if(self.shouldAutoreverse && animationShouldNotRepeat) {
            completionBlock = ^ (BOOL animationIsComplete) {
                if(animationIsComplete){}
                [self autoreverseAnimation:^ { super.frame = oldFrame;}];
            };
        }
        [self animateWithBlock:animationBlock completion:completionBlock];
    }
}

-(void)setBounds:(CGRect)bounds {
    if(_animationDuration == 0.0f) super.bounds = bounds;
    else {
        CGRect oldBounds = self.bounds;
        
        void (^animationBlock) (void) = ^ { super.bounds = bounds; };
        void (^completionBlock) (BOOL) = nil;
        
        BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
        if(self.shouldAutoreverse && animationShouldNotRepeat) {
            completionBlock = ^ (BOOL animationIsComplete) {
                if(animationIsComplete){}
                [self autoreverseAnimation:^ { super.bounds = oldBounds;}];
            };
        }
        
        [self animateWithBlock:animationBlock completion:completionBlock];
    }
}

-(void)setTransform:(CGAffineTransform)transform {
    if(_animationDuration == 0.0f) super.transform = transform;
    else {
        CGAffineTransform oldTransform = self.transform;
        
        void (^animationBlock) (void) = ^ { super.transform = transform; };
        void (^completionBlock) (BOOL) = nil;
        
        BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
        if(self.shouldAutoreverse && animationShouldNotRepeat) {
            completionBlock = ^ (BOOL animationIsComplete) {
                if(animationIsComplete){}
                [self autoreverseAnimation:^ { super.transform = oldTransform;}];
            };
        }
        
        [self animateWithBlock:animationBlock completion:completionBlock];
    }
}

-(void)setAlpha:(CGFloat)alpha {
    if(_animationDuration == 0.0f) super.alpha = alpha;
    else {
        CGFloat oldAlpha = self.alpha;
        
        void (^animationBlock) (void) = ^ { super.alpha = alpha; };
        void (^completionBlock) (BOOL) = nil;
        
        BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
        if(self.shouldAutoreverse && animationShouldNotRepeat) {
            completionBlock = ^ (BOOL animationIsComplete) {
                if(animationIsComplete){}
                [self autoreverseAnimation:^ { super.alpha = oldAlpha;}];
            };
        }
        
        [self animateWithBlock:animationBlock completion:completionBlock];
    }
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    if(_animationDuration == 0.0f) super.backgroundColor = backgroundColor;
    else {
        UIColor *oldBackgroundColor = self.backgroundColor;
        
        void (^animationBlock) (void) = ^ { super.backgroundColor = backgroundColor; };
        void (^completionBlock) (BOOL) = nil;
        
        BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
        if(self.shouldAutoreverse && animationShouldNotRepeat) {
            completionBlock = ^ (BOOL animationIsComplete) {
                if(animationIsComplete){}
                [self autoreverseAnimation:^ { super.backgroundColor = oldBackgroundColor;}];
            };
        }
        
        [self animateWithBlock:animationBlock completion:completionBlock];
    }
}

#pragma mark Position, Rotation, Transform
-(CGFloat)width {
    return self.bounds.size.width;
}

-(CGFloat)height {
    return self.bounds.size.height;
}

-(CGFloat)zPosition {
    return self.layer.zPosition;
}

-(CGSize)size {
    return self.bounds.size;
}

-(void)setZPosition:(CGFloat)zPosition {
    if(self.animationDuration == 0.0f) self.layer.zPosition = zPosition;
    else [(id <C4LayerAnimation>)self.layer animateZPosition:zPosition];
}

-(void)setRotation:(CGFloat)rotation {
    if(self.animationDuration == 0.0f) [self _setRotation:@(rotation)];
    else [self performSelector:@selector(_setRotation:)
                    withObject:@(rotation)
                    afterDelay:self.animationDelay];
}

-(void)_setRotation:(NSNumber *)rotation {
    _rotation = [rotation floatValue];
    [(id <C4LayerAnimation>)self.layer animateRotation:_rotation];
}

-(void)setRotationX:(CGFloat)rotation {
    if(self.animationDelay == 0.0f) [self _setRotationX:@(rotation)];
    else [self performSelector:@selector(_setRotationX:)
                    withObject:@(rotation)
                    afterDelay:self.animationDelay];
}

-(void)_setRotationX:(NSNumber *)rotation {
    _rotationX = [rotation floatValue];
    [(id <C4LayerAnimation>)self.layer animateRotationX:_rotationX];
}

-(void)setRotationY:(CGFloat)rotation {
    if(self.animationDelay == 0.0f) [self _setRotationY:@(rotation)];
    else [self performSelector:@selector(_setRotationY:)
                    withObject:@(rotation)
                    afterDelay:self.animationDelay];
}

-(void)_setRotationY:(NSNumber *)rotation {
    _rotationY = [rotation floatValue];
    [(id <C4LayerAnimation>)self.layer animateRotationY:_rotationY];
}

-(void)rotationDidFinish:(CGFloat)rotation {
    [super setTransform:CGAffineTransformMakeRotation(rotation)];
}

-(void)setLayerTransform:(CATransform3D)transform {
    _layerTransform = transform;
    [(id <C4LayerAnimation>)self.layer animateLayerTransform:transform];
}

-(void)setAnchorPoint:(CGPoint)anchorPoint {
    _anchorPoint = anchorPoint;
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = anchorPoint;
    super.frame = oldFrame;
}

-(void)setPerspectiveDistance:(CGFloat)distance {
    _perspectiveDistance = distance;
    [(id <C4LayerAnimation>)self.layer setPerspectiveDistance:distance];
}

#pragma mark Animation methods
-(void)animateWithBlock:(void (^)(void))animationBlock {
    [self animateWithBlock:animationBlock completion:nil];
}

-(void)animateWithBlock:(void (^)(void))animationBlock completion:(void (^)(BOOL))completionBlock {
    C4AnimationOptions autoReverseOptions = self.animationOptions;
    //we insert the autoreverse options here, only if it should repeat and autoreverse
    if(self.shouldAutoreverse && (self.animationOptions & REPEAT) == REPEAT) {
        autoReverseOptions |= AUTOREVERSE;
    }
    
    [UIView animateWithDuration:self.animationDuration
                          delay:(NSTimeInterval)self.animationDelay
                        options:(UIViewAnimationOptions)autoReverseOptions
                     animations:animationBlock
                     completion:completionBlock];
}

-(void)autoreverseAnimation:(void (^)(void))animationBlock {
    C4AnimationOptions autoreverseOptions = BEGINCURRENT;
    if((self.animationOptions & LINEAR) == LINEAR) autoreverseOptions |= LINEAR;
    else if((self.animationOptions & EASEIN) == EASEIN) autoreverseOptions |= EASEOUT;
    else if((self.animationOptions & EASEOUT) == EASEOUT) autoreverseOptions |= EASEIN;
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0
                        options:(UIViewAnimationOptions)autoreverseOptions
                     animations:animationBlock
                     completion:nil];
}

-(void)setAnimationDuration:(CGFloat)duration {
//    if (duration <= 0.0f) duration = 0.0001f;
    _animationDuration = duration;
    ((id <C4LayerAnimation>)self.layer).animationDuration = duration;
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    /*
     important: we have to intercept the setting of AUTOREVERSE for the case of reversing 1 time
     i.e. reversing without having set REPEAT
     
     UIView animation will flicker if we don't do this...
     */
    ((id <C4LayerAnimation>)self.layer).animationOptions = animationOptions;
    
    if ((animationOptions & AUTOREVERSE) == AUTOREVERSE) {
        self.shouldAutoreverse = YES;
        animationOptions &= ~AUTOREVERSE;
    }
    
    _animationOptions = animationOptions | BEGINCURRENT;
}

#pragma mark Gesture Methods

-(void)addGesture:(C4GestureType)type name:(NSString *)gestureName action:(NSString *)methodName {}

-(UIGestureRecognizer *)gestureForName:(NSString *)gestureName {
    return nil;
}

-(NSDictionary *)allGestures {
    return nil;
}

-(void)numberOfTapsRequired:(NSInteger)tapCount forGesture:(NSString *)gestureName {}

-(void)numberOfTouchesRequired:(NSInteger)touchCount forGesture:(NSString *)gestureName {}

-(void)minimumPressDuration:(CGFloat)duration forGesture:(NSString *)gestureName {}

-(void)minimumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {}

-(void)maximumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {}

-(void)swipeDirection:(C4SwipeDirection)direction forGesture:(NSString *)gestureName {}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {}

-(void)touchesBegan {}

-(void)touchesEnded {}

-(void)touchesMoved {}

-(void)swipedRight:(id)sender {}

-(void)swipedLeft:(id)sender {}

-(void)swipedUp:(id)sender {}

-(void)swipedDown:(id)sender {}

-(void)tapped:(id)sender {}

-(void)tapped {}

-(void)swipedUp {}

-(void)swipedDown {}

-(void)swipedLeft {}

-(void)swipedRight {}

-(void)pressedLong {}

-(void)pressedLong:(id)sender {}

-(void)move:(id)sender {}

#pragma mark Notification Methods
-(void)listenFor:(NSString *)notification andRunMethod:(NSString *)methodName {}

-(void)listenFor:(NSString *)notification
       fromObject:(id)object
     andRunMethod:(NSString *)methodName {}

-(void)listenFor:(NSString *)notification
      fromObjects:(NSArray *)objectArray
     andRunMethod:(NSString *)methodName {}

-(void)stopListeningFor:(NSString *)methodName {}

-(void)stopListeningFor:(NSString *)methodName object:(id)object {}

-(void)stopListeningFor:(NSString *)methodName objects:(NSArray *)objectArray {}

-(void)postNotification:(NSString *)notification {}

#pragma mark C4AddSubview
+(void)copyMethods {}

-(void)addCamera:(C4Camera *)camera{}

-(void)addGL:(C4GL *)gl{}

-(void)addImage:(C4Image *)image{}

-(void)addLabel:(C4Label *)label{}

-(void)addMovie:(C4Movie *)movie{}

-(void)addObjects:(NSArray *)array{}

-(void)addShape:(C4Shape *)shape{}

-(void)addUIElement:(id <C4UIElement> )object{}

-(void)removeObject:(id)visualObject{}

-(void)removeObjects:(NSArray *)array{}

#pragma mark Masking
-(void)setMask:(C4Control *)maskObject {
    self.layer.mask = maskObject.layer;
}

-(void)setMasksToBounds:(BOOL)masksToBounds {
    self.layer.masksToBounds = masksToBounds;
}

-(BOOL)masksToBounds {
    return self.layer.masksToBounds;
}

#pragma mark Shadow
-(void)setShadowColor:(UIColor *)shadowColor {
    if(self.animationDelay == 0) [self _setShadowColor:shadowColor];
    else [self performSelector:@selector(_setShadowColor:)
                    withObject:shadowColor
                    afterDelay:self.animationDelay];
}

-(void)_setShadowColor:(UIColor *)shadowColor {
    if(self.animationDuration == 0.0f) self.layer.shadowColor = shadowColor.CGColor;
    else [(id <C4LayerAnimation>)self.layer animateShadowColor:shadowColor.CGColor];
}

-(UIColor *)shadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

-(void)setShadowOffset:(CGSize)shadowOffset {
    if(self.animationDelay == 0) [self _setShadowOffSet:[NSValue valueWithCGSize:shadowOffset]];
    else [self performSelector:@selector(_setShadowOffSet:)
                    withObject:[NSValue valueWithCGSize:shadowOffset]
                    afterDelay:self.animationDelay];
}

-(void)_setShadowOffSet:(NSValue *)shadowOffset {
    if(self.animationDuration == 0.0f) self.layer.shadowOffset = [shadowOffset CGSizeValue];
    else [(id <C4LayerAnimation>)self.layer animateShadowOffset:[shadowOffset CGSizeValue]];
}

-(CGSize)shadowOffset {
    return self.layer.shadowOffset;
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity {
    if(self.animationDelay == 0) [self _setShadowOpacity:@(shadowOpacity)];
    else [self performSelector:@selector(_setShadowOpacity:)
                    withObject:@(shadowOpacity)
                    afterDelay:self.animationDelay];
}

-(void)_setShadowOpacity:(NSNumber *)shadowOpacity {
    if(self.animationDuration == 0.0f) self.layer.shadowOpacity = [shadowOpacity floatValue];
    else [(id <C4LayerAnimation>)self.layer animateShadowOpacity:[shadowOpacity floatValue]];
}

-(CGFloat)shadowOpacity {
    return self.layer.shadowOpacity;
}

-(void)setShadowPath:(CGPathRef)shadowPath {
    if(self.animationDelay == 0) [self _setShadowPath:(__bridge id)shadowPath];
    else [self performSelector:@selector(_setShadowPath:)
                    withObject:(__bridge id)shadowPath
                    afterDelay:self.animationDelay];
}

-(void)_setShadowPath:(id)shadowPath {
    if(self.animationDuration == 0.0f) self.layer.shadowPath = (__bridge CGPathRef)shadowPath;
    else [(id <C4LayerAnimation>)self.layer animateShadowPath:(__bridge CGPathRef)shadowPath];
}

-(CGPathRef)shadowPath {
    return self.layer.shadowPath;
}

-(void)setShadowRadius:(CGFloat)shadowRadius {
    if(self.animationDelay == 0) [self _setShadowRadius:@(shadowRadius)];
    [self performSelector:@selector(_setShadowRadius:)
               withObject:@(shadowRadius)
               afterDelay:self.animationDelay];
}

-(void)_setShadowRadius:(NSNumber *)shadowRadius {
    if(self.animationDuration == 0.0f) self.layer.shadowRadius = [shadowRadius floatValue];
    else [(id <C4LayerAnimation>)self.layer animateShadowRadius:[shadowRadius floatValue]];
}

-(CGFloat)shadowRadius {
    return self.layer.shadowRadius;
}

#pragma mark Border
-(void)setBorderColor:(UIColor *)borderColor {
    if(self.animationDuration == 0.0f) self.layer.borderColor = borderColor.CGColor;
    else [(id <C4LayerAnimation>)self.layer animateBorderColor:borderColor.CGColor];
}

-(UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth {
    if(self.animationDuration == 0.0f) self.layer.borderWidth = borderWidth;
    else [(id <C4LayerAnimation>)self.layer animateBorderWidth:borderWidth];
}

-(CGFloat)borderWidth {
    return self.layer.borderWidth;
}

-(void)setCornerRadius:(CGFloat)cornerRadius {
    if(self.animationDuration == 0.0f) self.layer.cornerRadius = cornerRadius;
    else [(id <C4LayerAnimation>)self.layer animateCornerRadius:cornerRadius];
}

-(CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

#pragma mark Basic Methods
+(Class)layerClass {
    return [C4Layer class];
}

-(NSDictionary *)style {
    //FIXME: Will never transfer nil for some properties
    //(let's deal with it later rather than solve a "potential" problem)
    NSMutableDictionary *controlStyle = [NSMutableDictionary dictionaryWithDictionary:
                                         @{
                                         @"alpha":@(self.alpha),
                                         @"borderColor":self.borderColor,
                                         @"borderWidth":@(self.borderWidth),
                                         @"cornerRadius":@(self.cornerRadius),
                                         @"masksToBounds":@(self.masksToBounds),
                                         @"shadowOpacity":@(self.shadowOpacity),
                                         @"shadowOffset":[NSValue valueWithCGSize:self.shadowOffset],
                                         @"shadowRadius":@(self.shadowRadius)
                                         }];
    if (self.backgroundColor != nil) [controlStyle setObject:self.backgroundColor
                                                      forKey:@"backgroundColor"];
    if (self.shadowColor != nil) [controlStyle setObject:self.shadowColor
                                                  forKey:@"shadowColor"];
    if(self.shadowPath == nil) {
        [controlStyle setObject:[NSNull null] forKey:@"shadowPath"];
    } else {
        [controlStyle setObject:(__bridge UIBezierPath *)self.shadowPath forKey:@"shadowPath"];
    }
    
    return (NSDictionary *)controlStyle;
}

-(void)setStyle:(NSDictionary *)style {
    NSArray *styleKeys = [style allKeys];
    NSString *key;
    
    //Control Style Values
    key = @"alpha";
    if([styleKeys containsObject:key]) self.alpha = [[style objectForKey:key] floatValue];
    
    key = @"backgroundColor";
    if([styleKeys containsObject:key]) self.backgroundColor = [style objectForKey:key];
    
    key = @"borderColor";
    if([styleKeys containsObject:key]) self.borderColor = [style objectForKey:key];
    
    key = @"borderWidth";
    if([styleKeys containsObject:key]) self.borderWidth = [[style objectForKey:key] floatValue];
    
    key = @"cornerRadius";
    if([styleKeys containsObject:key]) self.cornerRadius = [[style objectForKey:key] floatValue];
    
    key = @"masksToBounds";
    if([styleKeys containsObject:key]) self.masksToBounds = [[style objectForKey:key] boolValue];
    
    key = @"shadowColor";
    if([styleKeys containsObject:key]) self.shadowColor = [style objectForKey:key];
    
    key = @"shadowOpacity";
    if([styleKeys containsObject:key]) self.shadowOpacity = [[style objectForKey:key] floatValue];
    
    key = @"shadowOffset";
    if([styleKeys containsObject:key]) self.shadowOffset = [[style objectForKey:key] CGSizeValue];
    
    key = @"shadowPath";
    if([styleKeys containsObject:key]) {
        id object = [style objectForKey:key];
        
        if(object == [NSNull null]) {
            self.shadowPath = nil;
        } else {
            self.shadowPath = (__bridge CGPathRef)[style objectForKey:key];
        }
    }
    
    key = @"shadowRadius";
    if([styleKeys containsObject:key]) self.shadowRadius = [[style objectForKey:key] floatValue];
    
    //  FIXME: should the following be part of C4Control?
    //    key = @"maxTrackImage";
    //    if([styleKeys containsObject:key]) self.maxTrackImage = [style objectForKey:key];
    //
    //    key = @"maxTrackImageHighlighted";
    //    if([styleKeys containsObject:key]) self.maxTrackImageHighlighted = [style objectForKey:key];
    //
    //    key = @"maxTrackImageDisabled";
    //    if([styleKeys containsObject:key]) self.maxTrackImageDisabled = [style objectForKey:key];
    //
    //    key = @"maxTrackImageSelected";
    //    if([styleKeys containsObject:key]) self.maxTrackImageSelected = [style objectForKey:key];
    //
    //    key = @"minimumTrackTintColor";
    //    if([styleKeys containsObject:key]) self.minimumTrackTintColor = [style objectForKey:key];
    //
    //    key = @"maximumTrackTintColor";
    //    if([styleKeys containsObject:key]) self.maximumTrackTintColor = [style objectForKey:key];
    //
    //    key = @"thumbTintColor";
    //    if([styleKeys containsObject:key]) self.thumbTintColor = [style objectForKey:key];

}

+(C4Control *)defaultStyle {
    return (C4Control *)[C4Control appearance];
}

-(C4Control *)copyWithZone:(NSZone *)zone {
    C4Control *control = [[C4Control allocWithZone:zone] initWithFrame:self.frame];
    control.style = self.style;
    return control;
}

-(id)nullForNilObject:(id)object {
    if(object == nil) return [NSNull null];
    return object;
}

-(id)nilForNullObject:(id)object {
    if(object == [NSNull null]) return nil;
    return object;
}

-(void)renderInContext:(CGContextRef)context {
//    CGContextSaveGState(context);
//    CGContextConcatCTM(context, self.layer.affineTransform);
    [self.layer renderInContext:context];
//    CGContextRestoreGState(context);
}

#pragma mark C4MethodDelay
-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds {}

-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds {}

@end