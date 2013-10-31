//
//  C4MethodDelayIMP.m
//  C4iOS
//
//  Created by travis on 2013-10-31.
//  Copyright (c) 2013 Slant. All rights reserved.
//

#import "C4MethodDelayIMP.h"

static C4MethodDelayIMP *sharedC4MethodDelayIMP = nil;

@implementation C4MethodDelayIMP

+(C4MethodDelayIMP *)sharedManager {
    if (sharedC4MethodDelayIMP == nil) {
        static dispatch_once_t once;
        dispatch_once(&once, ^ { sharedC4MethodDelayIMP = [[super allocWithZone:NULL] init];
        });
    }
    return sharedC4MethodDelayIMP;
}

//This method should only ever be copied by another class
//The other class will then run this method
//This method should never be run by the class itself
+(void)copyMethods {
    unsigned int methodListCount;
    Method *methodList = class_copyMethodList([C4AddSubviewIMP class], &methodListCount);
    for(int i = 0; i < methodListCount; i ++) {
        Method m = methodList[i];
        class_replaceMethod([self class], method_getName(m), method_getImplementation(m), method_getTypeEncoding(m));
    }
}

-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:self afterDelay:seconds];
}

-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:object afterDelay:seconds];
}

@end
