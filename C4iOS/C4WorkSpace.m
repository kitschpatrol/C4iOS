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

@implementation C4WorkSpace
{
    NSMutableArray * array;
    int density;
}

-(void)setup
{
    density = 4;
    
    array = [NSMutableArray new]; // set up array
    
//    [self mondrian:density withFrame: self.canvas.bounds];
}

-(void) mondrian: (int) N withFrame:(CGRect) r
{
    if (N == 0)
    {
        // create a shape with a square with a random color that fills the rect
        C4Shape * s = [C4Shape rect:r];
        [s setFillColor:[UIColor colorWithRed:[C4Math randomInt:1000]/1000.0f green:[C4Math randomInt:1000]/1000.0f blue:[C4Math randomInt:1000]/1000.0f alpha:1.0f]];
        [s setStrokeColor:[UIColor blackColor]];
        [self.canvas addShape:s];
        s.userInteractionEnabled = NO;
        [array addObject:s];
    }
    else
    {
        // if N > 0 then slice up the CGRect into 4 subsections
        CGRect f1, f2, f3, f4, f5, f6;// we'll use these to hold our new divisions
        /// randomly pick a point in the middle of the CGRect
        int i = [C4Math randomInt:r.size.width];
        int j = [C4Math randomInt:r.size.height];
        
        // the following uses CGRectDivide in CGGeometry
        // there isn't much info on it in the world
        // this helps:  http://nshipster.com/cggeometry/
        // you're best to just try it out
        
        // take the CGRect and divide it horizontally and store
        // the results in f1 and f2
        CGRectDivide(r, &f1, &f2, i, CGRectMinXEdge);
        
        // take f1 and divide it vertically and store the resulting
        // two squares in f3 and f4
        CGRectDivide(f1, &f3, &f4, j, CGRectMinYEdge);
        // ditto above but with f2
        CGRectDivide(f2, &f5, &f6, j, CGRectMinYEdge);
        
        // recurse 4 times. once for every subdivision of the frame.
        [self mondrian:N-1 withFrame:f3];
        [self mondrian:N-1 withFrame:f4];
        [self mondrian:N-1 withFrame:f5];
        [self mondrian:N-1 withFrame:f6];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    C4Log(@"hi");
}

-(void) touchesBegan
{
    /// remove the old shapes
    for ( C4Shape * s in array)
        [s removeFromSuperview];
    
    /// make a new painting
    [self mondrian:density withFrame: self.canvas.frame];
}
@end