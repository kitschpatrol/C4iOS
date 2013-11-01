//
//  C4VisibleObjectIMP.h
//  C4iOS
//
//  Created by travis on 2013-10-31.
//  Copyright (c) 2013 Slant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface C4VisibleObjectIMP : UIView <C4VisibleObject>
+(C4VisibleObjectIMP *)sharedManager;
@end
