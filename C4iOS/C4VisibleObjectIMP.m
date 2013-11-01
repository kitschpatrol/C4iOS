//
//  C4VisibleObjectIMP.m
//  C4iOS
//
//  Created by travis on 2013-10-31.
//  Copyright (c) 2013 Slant. All rights reserved.
//

#import "C4VisibleObjectIMP.h"

@interface C4VisibleObjectIMP()
@property (nonatomic) BOOL shouldAutoreverse;
@property (nonatomic, strong) NSString *longPressMethodName;
@property (nonatomic, strong) NSMutableDictionary *gestureDictionary;
@property (nonatomic, readonly) NSArray *stylePropertyNames;
@end

static C4VisibleObjectIMP *sharedC4VisualObjectIMP = nil;

@implementation C4VisibleObjectIMP

+(C4VisibleObjectIMP *)sharedManager {
    if (sharedC4VisualObjectIMP == nil) {
        static dispatch_once_t once;
        dispatch_once(&once, ^ { sharedC4VisualObjectIMP = [[super allocWithZone:NULL] init];
        });
    }
    return sharedC4VisualObjectIMP;
}

//This method should only ever be copied by another class
//The other class will then run this method
//This method should never be run by the class itself
+(void)copyMethods {
    //get a count of the number of methods in this class
    unsigned int methodListCount;
    //get the list of methods
    Method *methodList = class_copyMethodList([C4VisibleObjectIMP class], &methodListCount);
    
    //cycle through all the methods in the list
    for(int i = 0; i < methodListCount; i ++) {
        //grab the current method
        Method m = methodList[i];
        //get the method's name
        SEL name = method_getName(m);
        //get the method's implementation
        IMP implementation = method_getImplementation(m);
        //get the method's types
        const char *types = method_getTypeEncoding(m);
        //convert the name to a string
        NSString *selectorName = NSStringFromSelector(method_getName(m));
        //check the selector name
        if(![selectorName isEqualToString:@".cxx_destruct"] &&
           ![selectorName isEqualToString:@"setAnimationDuration"] &&
           ![selectorName isEqualToString:@"setAnimationOptions"]) {
            
            //if the selector name is NOT .cxx_destruct
            //replace the implmentation of the method m in the current class
            //with the current method's implementation
            //FIXME: there's something wrong with the view in the canvas receiving touches twice
            class_replaceMethod([self class], name, implementation, types);
        }
    }
}

-(void)setup {}
-(void)test { C4Log(@"%@ | %@",NSStringFromSelector(_cmd),[self class]); }

#pragma mark Animation Properties
@synthesize animationDuration = _animationDuration, animationDelay = _animationDelay, animationOptions = _animationOptions, repeatCount = _repeatCount;
@synthesize shadowColor = _shadowColor, shadowOffset = _shadowOffset, shadowOpacity = _shadowOpacity, shadowPath = _shadowPath, shadowRadius = _shadowRadius;
@synthesize masksToBounds = _masksToBounds, layerTransform = _layerTransform, mask = _mask;
@synthesize origin = _origin, width = _width, height = _height, size = _size;
@synthesize anchorPoint = _anchorPoint, borderColor = _borderColor, borderWidth = _borderWidth, cornerRadius = _cornerRadius;
@synthesize perspectiveDistance = _perspectiveDistance, rotation = _rotation, rotationX = _rotationX, rotationY = _rotationY, zPosition = _zPosition;

#pragma mark Style Properties
@synthesize style = _style;

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

-(CGPoint)origin {
    return self.frame.origin;
}

-(CGPoint)center {
    CGPoint currentCenter = self.origin;
    currentCenter.x += self.width / 2.0f;
    currentCenter.y += self.height / 2.0f;
    return currentCenter;
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

-(void)postNotification:(NSString *)string{}

#pragma mark Touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self postNotification:@"touchesBegan"];
    [self touchesBegan];
    C4Log(@"%@",[self class]);
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self postNotification:@"touchesMoved"];
    [self touchesMoved];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self postNotification:@"touchesEnded"];
    [self touchesEnded];
}

-(void)touchesBegan {}

-(void)touchesEnded {}

-(void)touchesMoved {}

#pragma mark Basic Methods
+(Class)layerClass {
    return [C4Layer class];
}

#pragma mark - other
-(void)renderInContext:(CGContextRef)context {
    [self.layer renderInContext:context];
}

@end
