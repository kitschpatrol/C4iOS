//
//  C4CanvasController.m
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


#import "C4CanvasController.h"
#import <objc/message.h>

@interface C4CanvasController ()
@property (atomic, strong) NSString *longPressMethodName;
@property (atomic, strong) NSMutableDictionary *gestureDictionary;
@end

@implementation C4CanvasController
@synthesize canvas = _canvas;

-(id)init {
    self = [super init];
    if(self != nil) {
        self.view = [[C4View alloc] initWithFrame:self.view.frame];
        _canvas = (C4Window *)self.view;
        [self listenFor:@"movieIsReadyForPlayback" andRunMethod:@"movieIsReadyForPlayback:"];
    }
    return self;
}

-(void)dealloc {
    self.longPressMethodName = nil;
    NSEnumerator *enumerator = [self.gestureDictionary keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        UIGestureRecognizer *g = (self.gestureDictionary)[key];
        [g removeTarget:self action:nil];
        [self.canvas removeGestureRecognizer:g];
    }
    [self.gestureDictionary removeAllObjects];
    self.gestureDictionary = nil;
    _canvas = nil;
}

-(void)setup {
}

-(C4Window *)canvas {
    return (C4Window *)self.view;
}

#pragma mark C4AddSubview
/*
 Methods in this implementatiof the C4AddSubview protocol cannot be copied because the 
 canvas controller is NOT a subclass of UIView and cannot call [super addSubview:];
 */


-(void)addCamera:(C4Camera *)camera {
    C4Assert([camera isKindOfClass:[C4Camera class]],
             @"You tried to add a %@ using [canvas addCamera:]", [camera class]);
    [self.canvas addSubview:camera];
    [camera initCapture];
    [self listenFor:@"imageWasCaptured" fromObject:camera andRunMethod:@"imageWasCaptured"];
}

-(void)addShape:(C4Shape *)shape {
    C4Assert([shape isKindOfClass:[C4Shape class]],
             @"You tried to add a %@ using [obj addShape:]", [shape class]);
    [(C4View *)self.view addSubview:shape];
}

-(void)addSubview:(UIView *)subview {
    C4Assert(![[subview class] isKindOfClass:[C4Camera class]],
             @"You just tried to add a C4Camera using the addSubview: method, please use addCamera:");
    C4Assert(![[subview class] isKindOfClass:[C4Shape class]],
             @"You just tried to add a C4Shape using the addSubview: method, please use addShape:");
    C4Assert(![[subview class] isKindOfClass:[C4Movie class]],
             @"You just tried to add a C4Movie using the addSubview: method, please use addMovie:");
    C4Assert(![[subview class] isKindOfClass:[C4Image class]],
             @"You just tried to add a C4Image using the addSubview: method, please use addImage:");
    C4Assert(![[subview class] isKindOfClass:[C4GL class]],
             @"You just tried to add a C4GL using the addSubview: method, please use addGL:");
    C4Assert(![[subview class] isKindOfClass:[C4Label class]],
             @"You just tried to add a C4Label using the addSubview: method, please use addLabel:");
    [(C4View *)self.view addSubview:subview];
}

-(void)addUIElement:(id<C4UIElement>)object {
    C4Assert(![[object class] conformsToProtocol:@protocol(C4UIElement)],
             @"You just tried to add a %@ using  [obj addUIElement:]", [object class]);
    [(C4View *)self.view addSubview:(UIView *)object];
}

-(void)addLabel:(C4Label *)label {
    C4Assert([label isKindOfClass:[C4Label class]],
             @"You tried to add a %@ using [obj addLabel:]", [label class]);
    [(C4View *)self.view addSubview:label];
}

-(void)addGL:(C4GL *)gl {
    C4Assert([gl isKindOfClass:[C4GL class]],
             @"You tried to add a %@ using [obj addGL:]", [gl class]);
    [(C4View *)self.view addSubview:gl];
}

-(void)addImage:(C4Image *)image {
    C4Assert([image isKindOfClass:[C4Image class]],
             @"You tried to add a %@ using [obj addImage:]", [image class]);
    [(C4View *)self.view addSubview:image];
}

-(void)addMovie:(C4Movie *)movie {
    C4Assert([movie isKindOfClass:[C4Movie class]],
             @"You tried to add a %@ using [obj addMovie:]", [movie class]);
    [(C4View *)self.view addSubview:movie];
}

-(void)addObjects:(NSArray *)array {
    for(id obj in array) {
        if([obj isKindOfClass:[C4Shape class]]) {
            [self addShape:obj];
        }
        else if([obj isKindOfClass:[C4GL class]]) {
            [self addGL:obj];
        }
        else if([obj isKindOfClass:[C4Image class]]) {
            [self addImage:obj];
        }
        else if([obj isKindOfClass:[C4Movie class]]) {
            [self addMovie:obj];
        }
        else if([obj isKindOfClass:[C4Camera class]]) {
            [self addCamera:obj];
        }
        else if([obj isKindOfClass:[UIView class]]) {
            [self addSubview:obj];
        }
        else if([obj conformsToProtocol:NSProtocolFromString(@"C4UIElement")]) {
            [self addSubview:obj];
        }
        else {
            C4Log(@"unable to determine type of class");
        }
    }
}

-(void)removeObject:(id)visualObject {
    C4Assert(self != visualObject,
             @"You tried to remove %@ from itself, don't be silly",
             visualObject);
    if([visualObject isKindOfClass:[UIView class]] ||
       [visualObject isKindOfClass:[C4Control class]])
        [visualObject removeFromSuperview];
    else C4Log(@"object (%@) you wish to remove is not a visual object", visualObject);
}

-(void)removeObjects:(NSArray *)array {
    for(id obj in array) {
        [self removeObject:obj];
    }
}

+(void)copyMethods{}

#pragma mark Notification Methods
-(void)listenFor:(NSString *)notification andRunMethod:(NSString *)methodName {
    [self listenFor:notification fromObject:nil andRunMethod:methodName];
}

-(void)listenFor:(NSString *)notification
       fromObject:(id)object
     andRunMethod:(NSString *)methodName {
    if([methodName isEqualToString:@"swipedUp"] ||
       [methodName isEqualToString:@"swipedDown"] ||
       [methodName isEqualToString:@"swipedLeft"] ||
       [methodName isEqualToString:@"swipedRight"] ||
       [methodName isEqualToString:@"tapped"]) {
        methodName = [methodName stringByAppendingString:@":"];
    }
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName)
                                                 name:notification
                                               object:object];
}

-(void)listenFor:(NSString *)notification
      fromObjects:(NSArray *)objectArray
     andRunMethod:(NSString *)methodName {
    for (id object in objectArray) {
        [self listenFor:notification fromObject:object andRunMethod:methodName];
    }
}

-(void)stopListeningFor:(NSString *)notification {
    [self stopListeningFor:notification object:nil];
}

-(void)stopListeningFor:(NSString *)notification object:(id)object {
   	[[NSNotificationCenter defaultCenter] removeObserver:self name:notification object:object];
}

-(void)stopListeningFor:(NSString *)methodName objects:(NSArray *)objectArray {
    for(id object in objectArray) {
        [self stopListeningFor:methodName object:object];
    }
}

-(void)postNotification:(NSString *)notification {
	[[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}

#pragma mark New Stuff

-(void)imageWasCaptured {
    
}

#pragma mark Gesture Methods

-(void)addGesture:(C4GestureType)type name:(NSString *)gestureName action:(NSString *)methodName {
    if(self.gestureDictionary == nil) self.gestureDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    BOOL containsGesture = ((self.gestureDictionary)[gestureName] != nil);
    
    if([methodName isEqualToString:@"swipedUp"] ||
       [methodName isEqualToString:@"swipedDown"] ||
       [methodName isEqualToString:@"swipedLeft"] ||
       [methodName isEqualToString:@"swipedRight"] ||
       [methodName isEqualToString:@"tapped"]) {
        methodName = [methodName stringByAppendingString:@":"];
    }

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
        [self.canvas addGestureRecognizer:recognizer];
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
    if([recognizer isKindOfClass:[UITapGestureRecognizer class]])
        ((UITapGestureRecognizer *) recognizer).numberOfTapsRequired = tapCount;
    else if([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        ((UILongPressGestureRecognizer *) recognizer).numberOfTapsRequired = tapCount;
    }
}

-(void)numberOfTouchesRequired:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    if([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        ((UITapGestureRecognizer *) recognizer).numberOfTouchesRequired = touchCount;
    }
    else if([recognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        ((UISwipeGestureRecognizer *) recognizer).numberOfTouchesRequired = touchCount;
    }
    else if([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        ((UILongPressGestureRecognizer *) recognizer).numberOfTouchesRequired = touchCount;
    }
}

-(void)minimumPressDuration:(CGFloat)duration forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    if([recognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        ((UILongPressGestureRecognizer *) recognizer).minimumPressDuration = duration;
}

-(void)minimumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    if([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        ((UIPanGestureRecognizer *) recognizer).minimumNumberOfTouches = touchCount;
    }
}

-(void)maximumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    if([recognizer isKindOfClass:[UIPanGestureRecognizer class]])
        ((UIPanGestureRecognizer *) recognizer).maximumNumberOfTouches = touchCount;
}

-(void)swipeDirection:(C4SwipeDirection)direction forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    if([recognizer isKindOfClass:[UISwipeGestureRecognizer class]])
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

-(void)pressedLong:(id)sender {
    if(((UIGestureRecognizer *)sender).state == UIGestureRecognizerStateBegan
       && [((UIGestureRecognizer *)sender) isKindOfClass:[UILongPressGestureRecognizer class]]) {
        if([self.longPressMethodName rangeOfString:@":"].location == NSNotFound) {
            objc_msgSend(self, NSSelectorFromString(self.longPressMethodName));
        } else {
            objc_msgSend(self, NSSelectorFromString(self.longPressMethodName),sender);
        }
    }
}

-(void)pressedLong {
}

-(void)move:(id)sender {
    sender = sender;
}

-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:self afterDelay:seconds];
}

-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:object afterDelay:seconds];
}

-(void)movieIsReadyForPlayback:(NSNotification *)notification {
    C4Movie *currentMovie = (C4Movie *)[notification object];
    [self movieIsReady:currentMovie];
    [self stopListeningFor:@"movieIsReadyForPlayback" object:currentMovie];
}

-(void)movieIsReady:(C4Movie *)movie {
    movie = movie;
}

@end