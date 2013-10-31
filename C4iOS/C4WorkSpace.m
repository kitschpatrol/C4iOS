//
//  C4WorkSpace.m
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

#import "C4WorkSpace.h"
#import "ClassA.h"
#import "ClassB.h"

@implementation C4WorkSpace {
    C4Shape *s;
}

-(void)setup {
    ClassA *objA = [ClassA new];
    ClassB *objB = [ClassB new];
    
    [objA methodA];
    [objA methodB];
    [objA methodC];
    
    [objB methodA];
    [objB methodB];
    [objB methodC];
    
    s = [C4Shape ellipse:CGRectMake(0, 0, 100, 100)];
    [self.canvas addShape:s];
    
    C4Shape *t = [C4Shape ellipse:CGRectMake(0, 0, 20, 20)];
    [s addShape:t];
    
    [self addGesture:TAP name:@"tap" action:@"test"];
}

-(void)test {
        s.animationDuration = 1.0f;
        s.animationOptions = AUTOREVERSE;
        s.lineWidth = 10.0f;
}

@end