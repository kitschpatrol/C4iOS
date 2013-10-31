//
//  C4Object.m
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

#import "C4Object.h"

@implementation C4Object

+(void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //NOTIFICATION
        //grabs a class method from ClassA
        //method being copied contains boilerplate code
        //for copying all other protocol methods
        Method copy = class_getClassMethod([C4NotificationIMP class], @selector(copyMethods));
        
        //local method into which we will set the implementation of "copy"
        Method local = class_getClassMethod([self class], @selector(copyMethods));
        
        //sets the implementation of "local" with that of "copy"
        method_setImplementation(local, method_getImplementation(copy));
        
        //implements, at a class level, the copy method for this class
        [[self class] copyMethods];
    });
}

+(void)copyMethods{}

-(id)init {
    self = [super init];
    if (self != nil) {
        [self setup];
    }
    return self;
}

-(void)setup {}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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

#pragma mark run methods
-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:self afterDelay:seconds];
}

-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:object afterDelay:seconds];
}

@end
