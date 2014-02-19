//
//  MGCVLayoutConstraintRulerExpander.m
//  MGResizableCollectionView
//
//  Created by Maros Galik on 2/11/14.
//  Copyright (c) 2014 Maros Galik. All rights reserved.
//

#import "MGCollectionViewLayoutConstraintRulerExpander.h"

#import "MG2DTransformations.h"

#import "MGResizableCollectionViewLayout.h"

@implementation MGCollectionViewLayoutConstraintRulerExpander

- (id)initWithConstraintCellSize:(CGSize)minCellSize
{
    if ( self = [super init] ) {
        _minSize = minCellSize;
    }
    
    return self;
}


- (NSMutableArray*)intersectedLayoutAttributesIn:(NSArray*)layoutAttributes
                                              by:(UICollectionViewLayoutAttributes*)intersecter
{
    NSMutableArray *intersectedAttributes = [NSMutableArray array];
    for ( UICollectionViewLayoutAttributes *anAttribute in layoutAttributes ) {
        if ( anAttribute == intersecter ) {
            continue;
        }
        
        // maybe bounds?
        if ( ! CGRectIntersectsRect(intersecter.frame, anAttribute.frame) ) {
            continue;
        }
        
        [intersectedAttributes addObject:anAttribute];
    }
    
    return intersectedAttributes;
}

- (CGRect)basedConstraintRectFromRect:(CGRect)mutatedRect
           directionOfInterferingRect:(MGDirection)directionFromInterference
{
    // check the miniminum size
    if ( CGRectGetWidth(mutatedRect) < self.minSize.width ) {
        if ( directionFromInterference & MGDirectionLeft ) {
            /* if it moves to left, don't just increatese the size, but also make sure,
             that the interferred rectangle is also shifted to the side */
            CGFloat deltaX = mutatedRect.size.width - self.minSize.width;
            mutatedRect.origin.x += deltaX;
        }
        mutatedRect.size.width = self.minSize.width;
    }
    
    if ( CGRectGetHeight(mutatedRect) < self.minSize.height ) {
        if ( directionFromInterference & MGDirectionUp ) {
            CGFloat deltaY = mutatedRect.size.height - self.minSize.height;
            mutatedRect.origin.y += deltaY;
        }
        mutatedRect.size.height = self.minSize.height;
    }
    
    return mutatedRect;
}

// returns a rect which we get by removing the content of subspace
// TODO: name it properly!
- (CGRect)rectMovedFromFrame:(CGRect)originalRectA
                movedToFrame:(CGRect)rectA
    interferredWithRectInFrame:(CGRect)rectB
directionOfRectAtransformation:(MGDirection)direction
{
    MGDirection directionOfTransforamtion = [MG2DTransformations positionOfRect:originalRectA 
                                                                         toRect:rectB];
    
//    NSLog(@"direction of transformation: %d", directionOfTransforamtion);
    
    CGRect rectC = rectB; // stays the same
    
    CGRect intersection = CGRectIntersection(rectA, rectB);
    if ( CGRectIsEmpty( intersection ) ) {
        // if there is no intersection, no modification of rectB is needed
        return rectC;
    }
    
    /* Moving Right (rectA is on left from rectB; e.g. intersection)
     
       e.g.      BBB
             => AABB
                 BBB
     */
    
    if ( directionOfTransforamtion == MGDirectionLeft && // source rectA is coming from LEFT
         (direction & MGDirectionRight) && // transformation ro rectB is made to right direction
         rectA.origin.x < rectB.origin.x &&
         CGRectGetMaxX(rectA) < CGRectGetMaxX(rectB) )
    {
        CGFloat C_x = rectA.origin.x + rectA.size.width;
        // the rectA is not overlapping the wbole rectB
        rectC = CGRectMake(C_x + 1,
                           rectB.origin.y,
                           rectB.size.width - (C_x - rectB.origin.x),
                           rectB.size.height);


    }
    rectB = rectC;
    intersection = CGRectIntersection(rectA, rectB);
    if ( CGRectIsEmpty( intersection ) ) {
        return [self basedConstraintRectFromRect:rectC
                      directionOfInterferingRect:direction];
    }

    
    /* Moving Left (rectA is on the right of rectB. rectA is moving left)
       
       e.g.  BBB
             BBAA <=
             BBB
     */
    if ( directionOfTransforamtion == MGDirectionRight && // source rectA is coming from right
         (direction & MGDirectionLeft) && // transformation to rectB is made to LEFT direction
         rectA.origin.x > rectB.origin.x &&
         rectA.origin.x < CGRectGetMaxX(rectB) )
    {

        CGFloat C_w = CGRectGetMinX( rectA ) - CGRectGetMinX( rectB );
        rectC = CGRectMake(rectB.origin.x,
                           rectB.origin.y,
                           C_w - 1,
                           rectB.size.height);
       
    }
    rectB = rectC;
    intersection = CGRectIntersection(rectA, rectB);
    if ( CGRectIsEmpty( intersection ) ) {
        return [self basedConstraintRectFromRect:rectC
                      directionOfInterferingRect:direction];
    }

    
    //
    /* Moving Down (rectA is above rectB; rectA is moving down)

       e.g.   A
             BAB    ||
             BBB    \/
             BBB
     */
    if ( directionOfTransforamtion == MGDirectionUp &&
        (direction & MGDirectionDown) &&
        CGRectGetMaxY(rectA) > rectB.origin.y &&
        CGRectGetMaxY(rectA) < CGRectGetMaxY(rectB) ) {
        
        rectC = rectB;
        CGFloat deltaY = CGRectGetMaxY(rectA) - rectB.origin.y;
        
        rectC = CGRectMake(rectB.origin.x,
                           rectB.origin.y + deltaY ,
                           rectB.size.width,
                           rectB.size.height - deltaY);
        
    }
    rectB = rectC;
    intersection = CGRectIntersection(rectA, rectB);
    if ( CGRectIsEmpty( intersection ) ) {
        return [self basedConstraintRectFromRect:rectC
                      directionOfInterferingRect:direction];
    }
    
    
    
    if ( directionOfTransforamtion == MGDirectionDown &&
         (direction & MGDirectionUp) &&
         rectA.origin.y >= rectB.origin.y &&
         rectA.origin.y <= CGRectGetMaxY(rectB) )
    {
        /* rectA is below rectB; rectA is moving up
            BBB
            BBB
            BAB   /\
             A    ||
         */

        rectC = CGRectMake(rectB.origin.x,
                           rectB.origin.y,
                           rectB.size.width,
                           rectA.origin.y - rectB.origin.y - 1);

    }


    
    // TODO: other possibilities - probably add a direction (i.e. left, right, top, down; to be able to see how a cell is resizing)
    

    return [self basedConstraintRectFromRect:rectC
                  directionOfInterferingRect:direction];

}


- (BOOL)collectionViewLayoutAttributes:(NSArray*)layoutAttributes
                layoutAttributeMutated:(UICollectionViewLayoutAttributes*)layoutAttributeMutated
                     fromOriginalFrame:(CGRect)originalFrame
{
    NSArray *intersectedArray = [self intersectedLayoutAttributesIn:layoutAttributes
                                                            by:layoutAttributeMutated];
    
    
    BOOL invalidateCollectionView = NO;
    
    for ( UICollectionViewLayoutAttributes *intersected in intersectedArray ) {
        
        MGDirection transformationDirection =
        [MG2DTransformations directionOfTransformationFromRect:originalFrame
                                             toTransformedRect:layoutAttributeMutated.frame];

        
        // TODO: pass also original rect, so we decide the side from where the rect comes from...
        CGRect resizedIntersectedRect =
        [self rectMovedFromFrame:originalFrame
                    movedToFrame:layoutAttributeMutated.frame
      interferredWithRectInFrame:intersected.frame
  directionOfRectAtransformation:transformationDirection];
        
        if ( ! CGRectEqualToRect(resizedIntersectedRect, intersected.frame) ) {
            CGRect originalFrame = intersected.frame;
            intersected.frame = resizedIntersectedRect;
            invalidateCollectionView = YES;
            
            // backtracking, except of mutated one
            NSMutableArray *mutatedAttributes = [NSMutableArray arrayWithArray:layoutAttributes];
            [mutatedAttributes removeObject:intersected];
            [self collectionViewLayoutAttributes:mutatedAttributes
                          layoutAttributeMutated:intersected
                               fromOriginalFrame:originalFrame];
        }
        
    }
    
    return invalidateCollectionView; // needs to invalidate the layout?
}

@end
