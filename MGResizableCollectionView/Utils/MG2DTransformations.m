//
//  MG2DTransformations.m
//  MGResizableCollectionView
//
//  Created by Maros Galik on 2/13/14.
//  Copyright (c) 2014 Maros Galik. All rights reserved.
//

#import "MG2DTransformations.h"

@implementation MG2DTransformations

+ (MGDirection)directionOfTransformationFromRect:(CGRect)originalRect
                               toTransformedRect:(CGRect)transformedRect
{
    MGDirection direction = MGDirectionUndefined;
    
    if ( CGRectGetMinX(originalRect) < CGRectGetMinX(transformedRect) ||
         CGRectGetMaxX(originalRect) < CGRectGetMaxX(transformedRect)) {
        direction |= MGDirectionRight;
    }
    else if ( CGRectGetMinX(originalRect) > CGRectGetMinX(transformedRect) ||
              CGRectGetMaxX(originalRect) > CGRectGetMaxX(transformedRect)) {
        direction |= MGDirectionLeft;
    }

    if ( CGRectGetMinY(originalRect) < CGRectGetMinY(transformedRect) ||
         CGRectGetMaxY(originalRect) < CGRectGetMaxY(transformedRect)) {
        direction |= MGDirectionDown;
    }
    else if ( CGRectGetMinY(originalRect) > CGRectGetMinY(transformedRect) ||
              CGRectGetMaxY(originalRect) > CGRectGetMaxY(transformedRect)) {
        direction |= MGDirectionUp;
    }
    
    return direction;
}

+ (MGDirection)positionOfRect:(CGRect)rectA
                       toRect:(CGRect)rectB
{
    if ( CGRectIntersectsRect(rectA, rectB) ) {
        // the calculcation doesn't work when to rectangles are overlapping each other
        return MGDirectionUndefined;
    }
  
    // TODO: maybe make rectA and rectB both super high and check whether they are overlapping or not?
    /*

        AAA        AAA        AAAA        AA
     1) AAA   , 2) AAA   , 3) AAAA  , 4)  AA
         BBB        BBB        BB        BBBB
         BBB        BBB        BB        BBBB
      includes cases when rectA is above rectB or vice versa
     */
    if (
         // 1)
         (CGRectGetMaxX(rectA) >= CGRectGetMinX(rectB) && CGRectGetMaxX(rectA) <= CGRectGetMaxX(rectB)) ||
         // 2)
         (CGRectGetMinX(rectA) >= CGRectGetMinX(rectB) && CGRectGetMinX(rectA) <= CGRectGetMaxX(rectB)) ||
         // 3)
         (CGRectGetMinX(rectA) <= CGRectGetMinX(rectB) && CGRectGetMaxX(rectA) >= CGRectGetMaxX(rectB)) ||
         // 4)
         (CGRectGetMinX(rectA) >= CGRectGetMinX(rectB) && CGRectGetMaxX(rectA) <= CGRectGetMaxX(rectB))
        )
    {
        if ( CGRectGetMaxY(rectA) <= CGRectGetMinY(rectB) ) {
            return MGDirectionUp;
        }
        
        if ( CGRectGetMinY(rectA) >= CGRectGetMaxY(rectB) ) {
            return MGDirectionDown;
        }
        
    }

    
    /*
        AAA              BBB      AAA             BBB
     1) AAABBB  , 2)  AAABBB , 3) AAABBB  , 4) AAABBB
           BBB        AAA         AAA             BBB
    
     includes cases when rectA is on the left side of rectB or vice versa
     */
    if (
        // 1
        (CGRectGetMaxY(rectA) >= CGRectGetMinY(rectB) && CGRectGetMaxY(rectA) <= CGRectGetMaxY(rectB)) ||
        // 2
        (CGRectGetMinY(rectA) >= CGRectGetMinY(rectB) && CGRectGetMinY(rectA) <= CGRectGetMaxY(rectB)) ||
        // 3)
        (CGRectGetMinY(rectA) <= CGRectGetMinY(rectB) && CGRectGetMaxY(rectA) >= CGRectGetMaxY(rectB)) ||
        // 4)
        (CGRectGetMinY(rectA) >= CGRectGetMinY(rectB) && CGRectGetMaxY(rectA) <= CGRectGetMaxY(rectB))
        )
    {
        if ( CGRectGetMaxX(rectA) <= CGRectGetMinX(rectB) ) {
            return MGDirectionLeft;
        }
        
        if ( CGRectGetMinX(rectA) >= CGRectGetMaxX(rectB) ) {
            return MGDirectionRight;
        }
    }
    
    return MGDirectionUndefined;
    
}

@end
