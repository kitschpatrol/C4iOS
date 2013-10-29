//
//  C4WorkSpace.m
//

#import "C4WorkSpace.h"
#import "Test.h"

@implementation C4WorkSpace

-(void)setup {
    C4Shape *circle = [C4Shape ellipse:CGRectMake(0, 0, 100, 100)];
    [self.canvas addShape:circle];
    
    Test *t = [Test rect:circle.frame];
    t.center = self.canvas.center;
    [self.canvas addShape:t];
}

@end