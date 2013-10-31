//
//  C4LayerAnimationImp.h
//  C4iOS
//
//  Created by travis on 2013-10-31.
//  Copyright (c) 2013 Slant. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface C4LayerAnimationImp : CALayer <C4LayerAnimation>
+(C4LayerAnimationImp *)sharedManager;
@end
