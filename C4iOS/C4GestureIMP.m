//
//  C4GestureIMP.m
//  C4iOS
//
//  Created by moi on 10/31/2013.
//  Copyright (c) 2013 Slant. All rights reserved.
//

#import "C4GestureIMP.h"

//methods and properties to suppress warnings
@interface C4GestureIMP ()
@property NSMutableDictionary *gestureDictionary;
@property NSString *longPressMethodName;
@property CGFloat animationDuration;
@property NSUInteger animationOptions;
@property CGFloat animationDelay;
@property UIView *view;
-(void)postNotification:(NSString *)notification;
-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds;
@end

static C4GestureIMP *sharedC4GestureIMP = nil;

@implementation C4GestureIMP

+(C4GestureIMP *)sharedManager {
    if (sharedC4GestureIMP == nil) {
        static dispatch_once_t once;
        dispatch_once(&once, ^ { sharedC4GestureIMP = [[super allocWithZone:NULL] init];
        });
    }
    return sharedC4GestureIMP;
}

//This method should only ever be copied by another class
//The other class will then run this method
//This method should never be run by the class itself
+(void)copyMethods {
    unsigned int methodListCount;
    Method *methodList = class_copyMethodList([C4GestureIMP class], &methodListCount);
    for(int i = 0; i < methodListCount; i ++) {
        Method m = methodList[i];
        class_replaceMethod([self class], method_getName(m), method_getImplementation(m), method_getTypeEncoding(m));
    }
}

-(void)addGesture:(C4GestureType)type name:(NSString *)gestureName action:(NSString *)methodName {
    if(self.gestureDictionary == nil) self.gestureDictionary = [@{} mutableCopy];
    BOOL containsGesture = ((self.gestureDictionary)[gestureName] != nil);
    if(containsGesture == NO) {
        UIGestureRecognizer *recognizer;
        SEL selector = NSSelectorFromString(methodName);
        if(type == LONGPRESS) selector = @selector(pressedLong:);
        switch (type) {
            case TAP:
                recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                     action:selector];
                break;
            case PAN:
                recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                     action:selector];
                break;
            case SWIPERIGHT:
                recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                       action:selector];
                ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRRIGHT;
                break;
            case SWIPELEFT:
                recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                       action:selector];
                ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRLEFT;
                break;
            case SWIPEUP:
                recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                       action:selector];
                ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRUP;
                break;
            case SWIPEDOWN:
                recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                       action:selector];
                ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRDOWN;
                break;
            case LONGPRESS:
                self.longPressMethodName = methodName;
                recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                           action:selector];
                break;
            default:
                C4Assert(NO,@"The gesture you tried to use is not one of: TAP, PINCH, SWIPERIGHT, SWIPELEFT, SWIPEUP, SWIPEDOWN, ROTATION, PAN, or LONGPRESS");
                break;
        }
        recognizer.delaysTouchesBegan = YES;
        recognizer.delaysTouchesEnded = YES;
        if([self isKindOfClass:[C4WorkSpace class]]) [(C4View *)self.view addGestureRecognizer:recognizer];
        else [self addGestureRecognizer:recognizer];
        (self.gestureDictionary)[gestureName] = recognizer;
    }
}

-(UIGestureRecognizer *)gestureForName:(NSString *)gestureName {
    return (self.gestureDictionary)[gestureName];
}

-(NSDictionary *)allGestures {
    return self.gestureDictionary;
}

-(void)numberOfTapsRequired:(NSInteger)tapCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    
    C4Assert([recognizer isKindOfClass:[UITapGestureRecognizer class]] ||
             [recognizer isKindOfClass:[UILongPressGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method: %@",
             [recognizer class],
             NSStringFromSelector(_cmd));
    
    ((UILongPressGestureRecognizer *) recognizer).numberOfTapsRequired = tapCount;
}

-(void)numberOfTouchesRequired:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    
    C4Assert([recognizer isKindOfClass:[UITapGestureRecognizer class]] ||
             [recognizer isKindOfClass:[UISwipeGestureRecognizer class]] ||
             [recognizer isKindOfClass:[UILongPressGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method: %@",
             [recognizer class],
             NSStringFromSelector(_cmd));
    
    ((UITapGestureRecognizer *) recognizer).numberOfTouchesRequired = touchCount;
}

-(void)minimumPressDuration:(CGFloat)duration forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    
    C4Assert([recognizer isKindOfClass:[UILongPressGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method %@",
             [recognizer class],
             NSStringFromSelector(_cmd));
    
    ((UILongPressGestureRecognizer *) recognizer).minimumPressDuration = duration;
}

-(void)minimumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    
    C4Assert([recognizer isKindOfClass:[UIPanGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method: %@",
             [recognizer class],
             NSStringFromSelector(_cmd));
    
    ((UIPanGestureRecognizer *) recognizer).minimumNumberOfTouches = touchCount;
}

-(void)maximumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    
    C4Assert([recognizer isKindOfClass:[UIPanGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method: %@",
             [recognizer class],
             NSStringFromSelector(_cmd));
    
    ((UIPanGestureRecognizer *) recognizer).maximumNumberOfTouches = touchCount;
}

-(void)swipeDirection:(C4SwipeDirection)direction forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    
    C4Assert([recognizer isKindOfClass:[UISwipeGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method: %@",
             [recognizer class],
             NSStringFromSelector(_cmd));
    
    ((UISwipeGestureRecognizer *) recognizer).direction = direction;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self postNotification:@"touchesBegan"];
    [self touchesBegan];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self postNotification:@"touchesMoved"];
    [self touchesMoved];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self postNotification:@"touchesEnded"];
    [self touchesEnded];
}

-(void)touchesBegan {
}

-(void)touchesEnded {
}

-(void)touchesMoved {
}

-(void)swipedRight:(id)sender {
    sender = sender;
    [self postNotification:@"swipedRight"];
    [self swipedRight];
}

-(void)swipedLeft:(id)sender {
    sender = sender;
    [self postNotification:@"swipedLeft"];
    [self swipedLeft];
}

-(void)swipedUp:(id)sender {
    sender = sender;
    [self postNotification:@"swipedUp"];
    [self swipedUp];
}

-(void)swipedDown:(id)sender {
    sender = sender;
    [self postNotification:@"swipedDown"];
    [self swipedDown];
}

-(void)tapped:(id)sender {
    sender = sender;
    [self postNotification:NSStringFromSelector(_cmd)];
    [self tapped];
}

-(void)tapped {
}


-(void)swipedUp {
}

-(void)swipedDown {
}

-(void)swipedLeft {
}

-(void)swipedRight {
}

-(void)pressedLong {
}

-(void)pressedLong:(id)sender {
    if(((UIGestureRecognizer *)sender).state == UIGestureRecognizerStateBegan
       && [((UIGestureRecognizer *)sender) isKindOfClass:[UILongPressGestureRecognizer class]]) {
        [self runMethod:self.longPressMethodName withObject:sender afterDelay:0.0f];
        [self postNotification:@"pressedLong"];
    }
}

-(void)move:(id)sender {
    UIPanGestureRecognizer *p = (UIPanGestureRecognizer *)sender;
    
    NSUInteger _ani = self.animationOptions;
    CGFloat _dur = self.animationDuration;
    CGFloat _del = self.animationDelay;
    self.animationDuration = 0;
    self.animationDelay = 0;
    self.animationOptions = DEFAULT;
    
    CGPoint translatedPoint = [p translationInView:self];
    
    translatedPoint.x += self.center.x;
    translatedPoint.y += self.center.y;
    
    self.center = translatedPoint;
    [p setTranslation:CGPointZero inView:self];
    [self postNotification:@"moved"];
    
    self.animationDelay = _del;
    self.animationDuration = _dur;
    self.animationOptions = _ani;
}

-(void)postNotification:(NSString *)notification {};
-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds{}
@end
