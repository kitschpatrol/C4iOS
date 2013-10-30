//
//  ClassB.m
//  C4iOS
//
//  Created by moi on 10/29/2013.
//  Copyright (c) 2013 Slant. All rights reserved.
//

#import "ClassB.h"
#import "ClassA.h"
#import <objc/runtime.h>

@implementation ClassB

//initialize loads the contents of another class's methods into this one
+(void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //grabs a class method from ClassA
        //method being copied contains boilerplate code
        //for copying all other protocol methods
        Method copy = class_getClassMethod([ClassA class],
                                           @selector(copyProtocolMethods));

        //local method into which we will set the implementation of "copy"
        Method local = class_getClassMethod([self class],
                                            @selector(copyProtocolMethods));
        
        //sets the implementation of "local" with that of "copy"
        method_setImplementation(local, method_getImplementation(copy));
        
        //implements, at a class level, the copy method for this class
        [[self class] copyProtocolMethods];
    });
}

+(void)copyProtocolMethods {}
-(void)methodA{}
-(void)methodB{}
@end
