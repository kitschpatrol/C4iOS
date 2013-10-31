//
//  C4MethodDelayIMP.h
//  C4iOS
//
//  Created by travis on 2013-10-31.
//  Copyright (c) 2013 Slant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface C4MethodDelayIMP : NSObject <C4MethodDelay>
+(C4MethodDelayIMP *)sharedManager;
@end
