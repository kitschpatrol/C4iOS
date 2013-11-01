//
//  C4Window.m
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

#import "C4Window.h"
@interface C4Window ()
@property (nonatomic) BOOL shouldAutoreverse;
@property (nonatomic, strong) NSString *longPressMethodName;
@property (nonatomic, strong) NSMutableDictionary *gestureDictionary;
@property (nonatomic, readonly) NSArray *stylePropertyNames;
@end

@implementation C4Window

+(void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void (^classCopyBlock)(Class) = ^(Class classToCopy) {
            //grabs a class method from classToCopy
            //method being copied contains boilerplate code
            //for copying all other protocol methods
            Method copy = class_getClassMethod(classToCopy, @selector(copyMethods));
            
            //local method into which we will set the implementation of "copy"
            Method local = class_getClassMethod([self class], @selector(copyMethods));
            
            //sets the implementation of "local" with that of "copy"
            method_setImplementation(local, method_getImplementation(copy));
            
            //implements, at a class level, the copy method for this class
            [[self class] copyMethods];
        };
        
        //Copies method implementations from C4VisibleObjectIMP
        classCopyBlock([C4VisibleObjectIMP class]);
        
        //Copies method implementations from C4MethodDelayIMP
        classCopyBlock([C4MethodDelayIMP class]);
        
        //Copies method implementations from C4GestureIMP
        classCopyBlock([C4GestureIMP class]);
        
        //Copies method implementations from C4NotificationIMP
        classCopyBlock([C4NotificationIMP class]);
        
        //Copies method implementations from C4AddSubviewIMP
        classCopyBlock([C4AddSubviewIMP class]);
    });
}

+(void)copyMethods {}

-(id)init {
    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        
        //these need to be self.anim... etc., rather than _anim = because the setters are overridden
        self.animationDuration = 0.0f;
        self.animationDelay = 0.0f;
//        self.animationOptions = BEGINCURRENT;
        self.repeatCount = 0;
        self.shouldAutoreverse = NO;
        self.longPressMethodName = @"pressedLong";
        self.layer.delegate = self;
        
//        self.style = [C4Window defaultStyle].style;
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

#pragma mark - C4VisibleObject
@synthesize animationDuration = _animationDuration, animationDelay = _animationDelay, animationOptions = _animationOptions, repeatCount = _repeatCount;
@synthesize shadowColor = _shadowColor, shadowOffset = _shadowOffset, shadowOpacity = _shadowOpacity, shadowPath = _shadowPath, shadowRadius = _shadowRadius;
@synthesize masksToBounds = _masksToBounds, layerTransform = _layerTransform, mask = _mask;
@synthesize origin = _origin, width = _width, height = _height, size = _size;
@synthesize anchorPoint = _anchorPoint, borderColor = _borderColor, borderWidth = _borderWidth, cornerRadius = _cornerRadius;
@synthesize perspectiveDistance = _perspectiveDistance, rotation = _rotation, rotationX = _rotationX, rotationY = _rotationY, zPosition = _zPosition;

#pragma mark Setup & Test
-(void)setup {}
-(void)test {}

#pragma mark Position & Size
-(void)setCenter:(CGPoint)center {}

-(CGPoint)origin { return CGPointZero; }

-(void)setOrigin:(CGPoint)origin {}

-(void)setFrame:(CGRect)frame {}

-(void)setBounds:(CGRect)bounds {}

-(void)setTransform:(CGAffineTransform)transform {}

-(CGFloat)width { return 0.0f; }

-(CGFloat)height { return 0.0f; }

-(CGFloat)zPosition { return 0.0f; }

-(CGSize)size { return CGSizeZero; }

-(void)setZPosition:(CGFloat)zPosition {}

#pragma mark Rotation & Transform
-(void)setRotation:(CGFloat)rotation {}

-(void)_setRotation:(NSNumber *)rotation {}

-(void)setRotationX:(CGFloat)rotation {}

-(void)_setRotationX:(NSNumber *)rotation {}

-(void)setRotationY:(CGFloat)rotation {}

-(void)_setRotationY:(NSNumber *)rotation {}

-(void)rotationDidFinish:(CGFloat)rotation {}

-(void)setLayerTransform:(CATransform3D)transform {}

-(void)setAnchorPoint:(CGPoint)anchorPoint {}

-(void)setPerspectiveDistance:(CGFloat)distance {}

#pragma mark Alpha & Background Color
-(void)setAlpha:(CGFloat)alpha {}

-(void)setBackgroundColor:(UIColor *)backgroundColor {}

#pragma mark Masking
-(void)setMask:(C4Control *)maskObject {}

-(void)setMasksToBounds:(BOOL)masksToBounds {}

-(BOOL)masksToBounds { return NO; }

#pragma mark Shadow
-(void)setShadowColor:(UIColor *)shadowColor {}

-(void)_setShadowColor:(UIColor *)shadowColor {}

-(UIColor *)shadowColor { return nil; }

-(void)setShadowOffset:(CGSize)shadowOffset {}

-(void)_setShadowOffSet:(NSValue *)shadowOffset {}

-(CGSize)shadowOffset { return CGSizeZero; }

-(void)setShadowOpacity:(CGFloat)shadowOpacity {}

-(void)_setShadowOpacity:(NSNumber *)shadowOpacity {}

-(CGFloat)shadowOpacity { return 0.0f; }

-(void)setShadowPath:(CGPathRef)shadowPath {}

-(void)_setShadowPath:(id)shadowPath {}

-(CGPathRef)shadowPath { return nil; }

-(void)setShadowRadius:(CGFloat)shadowRadius {}

-(void)_setShadowRadius:(NSNumber *)shadowRadius {}

-(CGFloat)shadowRadius { return 0.0f; }

#pragma mark Border
-(void)setBorderColor:(UIColor *)borderColor {}

-(UIColor *)borderColor { return nil;}

-(void)setBorderWidth:(CGFloat)borderWidth {}

-(CGFloat)borderWidth { return 0.0f; }

-(void)setCornerRadius:(CGFloat)cornerRadius {}

-(CGFloat)cornerRadius { return 0.0f; }

#pragma mark View Animation
-(void)animateWithBlock:(void (^)(void))animationBlock {}

-(void)animateWithBlock:(void (^)(void))animationBlock completion:(void (^)(BOOL))completionBlock {}

-(void)autoreverseAnimation:(void (^)(void))animationBlock {}

-(void)setAnimationDuration:(CGFloat)duration {}

-(void)setAnimationOptions:(NSUInteger)animationOptions {}

#pragma mark - C4Gesture

-(void)addGesture:(C4GestureType)type name:(NSString *)gestureName action:(NSString *)methodName {}

-(UIGestureRecognizer *)gestureForName:(NSString *)gestureName { return nil; }

-(NSDictionary *)allGestures { return nil; }

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

#pragma mark - C4Notification
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

#pragma mark - C4AddSubview
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

#pragma mark - Basic Methods
+(Class)layerClass { return [C4Layer class]; }

#pragma mark - Style
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
}

+(C4Control *)defaultStyle {
    return (C4Control *)[C4Control appearance];
}

#pragma mark - Render
-(void)renderInContext:(CGContextRef)context {}

#pragma mark - C4MethodDelay
-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds {}

-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds {}

#pragma mark - Copying
-(C4Control *)copyWithZone:(NSZone *)zone {
    C4Control *control = [[C4Control allocWithZone:zone] initWithFrame:self.frame];
    control.style = self.style;
    return control;
}
@end