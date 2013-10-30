//
//  ClassA.m
//  C4iOS
//
//  Created by moi on 10/29/2013.
//  Copyright (c) 2013 Slant. All rights reserved.
//

#import "ClassA.h"
#import <objc/runtime.h>

@implementation ClassA
//This method should only ever be copied by another class
//The other class will then run this method
//This method should never be run by the class itself
+(void)copyProtocolMethods {
    //gets methodA from ClassA
    Method methodA = class_getInstanceMethod([ClassA class],
                                             @selector(methodA));
    
    //replaces implementation of local methodA with that of methodA from ClassA
    class_replaceMethod([self class],
                        @selector(methodA),
                        method_getImplementation(methodA),
                        method_getTypeEncoding(methodA));
    
    //gets methodB from ClassA
    Method methodB = class_getInstanceMethod([ClassA class],
                                             @selector(methodB));

    //replaces implementation of local methodB with that of methodB from ClassA
    class_replaceMethod([self class],
                        @selector(methodB),
                        method_getImplementation(methodB),
                        method_getTypeEncoding(methodB));
}

//prints the selector name, and the name of the calling class
-(void)methodA {
    NSString *selectorName = NSStringFromSelector(_cmd);
    NSString *className = NSStringFromClass([self class]);
    C4Log(@"%@ | %@", selectorName, className);
}

//prints the selector name, and the name of the calling class
-(void)methodB {
    NSString *selectorName = NSStringFromSelector(_cmd);
    NSString *className = NSStringFromClass([self class]);
    C4Log(@"%@ | %@", selectorName, className);
}

@end
