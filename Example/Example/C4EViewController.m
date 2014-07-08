//
//  C4EViewController.m
//  Example
//
//  Created by Eric Mika on 7/8/14.
//  Copyright (c) 2014 C4. All rights reserved.
//

#import "C4EViewController.h"

@interface C4EViewController ()

@property (nonatomic, strong) C4Shape *circle;

@end

@implementation C4EViewController

- (void)setup {
  self.canvas.backgroundColor = C4BLUE;
  
  self.circle = [C4Shape ellipse:CGRectMake(0, 0, 100, 100)];
  self.circle.fillColor = C4RED;
  self.circle.center = CGPointMake(100, 100);
  
  [self.canvas addControl:self.circle];
}

-(void)tapped:(CGPoint)location {
  [self updateCirclePosition:location];
}

-(void)panned:(CGPoint)location translation:(CGPoint)translation velocity:(CGPoint)velocity {
  [self updateCirclePosition:location];
}

- (void)updateCirclePosition:(CGPoint)location {
  self.circle.center = location;
}

@end
