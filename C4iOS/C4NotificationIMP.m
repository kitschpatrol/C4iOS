//
//  C4NotificationIMP.m
//  C4iOS
//
//  Created by moi on 10/30/2013.
//  Copyright (c) 2013 Slant. All rights reserved.
//

#import "C4NotificationIMP.h"

static C4NotificationIMP *sharedC4NotificationIMP = nil;

@implementation C4NotificationIMP

+(C4NotificationIMP *)sharedManager {
    if (sharedC4NotificationIMP == nil) {
        static dispatch_once_t once;
        dispatch_once(&once, ^ { sharedC4NotificationIMP = [[super allocWithZone:NULL] init];
        });
    }
    return sharedC4NotificationIMP;
}

//This method should only ever be copied by another class
//The other class will then run this method
//This method should never be run by the class itself
+(void)copyMethods {
    unsigned int methodListCount;
    Method *methodList = class_copyMethodList([C4NotificationIMP class], &methodListCount);
    for(int i = 0; i < methodListCount; i ++) {
        Method m = methodList[i];
        class_replaceMethod([self class], method_getName(m), method_getImplementation(m), method_getTypeEncoding(m));
    }
}

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

@end
