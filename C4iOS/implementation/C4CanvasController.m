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

+(void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method copy;
        Method local;
        
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

        //grabs a class method from C4GestureIMP
        //method being copied contains boilerplate code
        //for copying all other protocol methods
        copy = class_getClassMethod([C4GestureIMP class], @selector(copyMethods));
        
        //local method into which we will set the implementation of "copy"
        local = class_getClassMethod([self class], @selector(copyMethods));
        
        //sets the implementation of "local" with that of "copy"
        method_setImplementation(local, method_getImplementation(copy));
        
        //implements, at a class level, the copy method for this class
        [[self class] copyMethods];

        //grabs a class method from C4NotificationIMP
        //method being copied contains boilerplate code
        //for copying all other protocol methods
        copy = class_getClassMethod([C4NotificationIMP class], @selector(copyMethods));
        
        //local method into which we will set the implementation of "copy"
        local = class_getClassMethod([self class], @selector(copyMethods));
        
        //sets the implementation of "local" with that of "copy"
        method_setImplementation(local, method_getImplementation(copy));
        
        //implements, at a class level, the copy method for this class
        [[self class] copyMethods];
});
}

+(void)copyMethods {}

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


#pragma mark Notification Methods
-(void)listenFor:(NSString *)notification andRunMethod:(NSString *)methodName {}

-(void)listenFor:(NSString *)notification
       fromObject:(id)object
     andRunMethod:(NSString *)methodName {}

-(void)listenFor:(NSString *)notification
      fromObjects:(NSArray *)objectArray
     andRunMethod:(NSString *)methodName {}

-(void)stopListeningFor:(NSString *)notification {}

-(void)stopListeningFor:(NSString *)notification object:(id)object {}

-(void)stopListeningFor:(NSString *)methodName objects:(NSArray *)objectArray {}

-(void)postNotification:(NSString *)notification {}

#pragma mark New Stuff

-(void)imageWasCaptured {}

#pragma mark Gesture Methods

-(void)addGesture:(C4GestureType)type name:(NSString *)gestureName action:(NSString *)methodName {}

-(UIGestureRecognizer *)gestureForName:(NSString *)gestureName { return nil; }

-(NSDictionary *)allGestures { return nil; }

-(void)numberOfTapsRequired:(NSInteger)tapCount forGesture:(NSString *)gestureName {}

-(void)numberOfTouchesRequired:(NSInteger)touchCount forGesture:(NSString *)gestureName {}

-(void)minimumPressDuration:(CGFloat)duration forGesture:(NSString *)gestureName {}

-(void)minimumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {}

-(void)maximumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {}

-(void)swipeDirection:(C4SwipeDirection)direction forGesture:(NSString *)gestureName {}

#pragma touch methods
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

-(void)pressedLong:(id)sender {}

-(void)pressedLong {}

-(void)move:(id)sender {}

#pragma mark run methods
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