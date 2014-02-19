//
//  MGResizableCollectionViewCell.m
//  SPUserResizableView, ResizableCollectionView
//  https://github.com/spoletto/SPUserResizableView
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Stephen Poletto on 12/10/11.
//  Modified by Maros Galik on 07/02/14


#import "MGResizableCollectionViewCell.h"

#import "MGResizableCollectionViewLayout.h"

#define kSPUserResizableViewGlobalInset 5.0
#define kSPUserResizableViewInteractiveBorderSize 10.


typedef struct SPUserResizableViewAnchorPoint {
    CGFloat adjustsX;
    CGFloat adjustsY;
    CGFloat adjustsH;
    CGFloat adjustsW;
} SPUserResizableViewAnchorPoint;

static SPUserResizableViewAnchorPoint SPUserResizableViewNoResizeAnchorPoint = { 0.0, 0.0, 0.0, 0.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewUpperLeftAnchorPoint = { 1.0, 1.0, -1.0, 1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewMiddleLeftAnchorPoint = { 1.0, 0.0, 0.0, 1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewLowerLeftAnchorPoint = { 1.0, 0.0, 1.0, 1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewUpperMiddleAnchorPoint = { 0.0, 1.0, -1.0, 0.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewUpperRightAnchorPoint = { 0.0, 1.0, -1.0, -1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewMiddleRightAnchorPoint = { 0.0, 0.0, 0.0, -1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewLowerRightAnchorPoint = { 0.0, 0.0, 1.0, -1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewLowerMiddleAnchorPoint = { 0.0, 0.0, 1.0, 0.0 };


@interface MGResizableCollectionViewCell ()

@property SPUserResizableViewAnchorPoint anchorPoint;
@property CGPoint touchStart;

@end

@implementation MGResizableCollectionViewCell

- (void)setupDefaultAttributes {
    self.preventsPositionOutsideSuperview = YES;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setupDefaultAttributes];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setupDefaultAttributes];
    }
    return self;
}

static CGFloat SPDistanceBetweenTwoPoints(CGPoint point1, CGPoint point2) {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy);
};

typedef struct CGPointSPUserResizableViewAnchorPointPair {
    CGPoint point;
    SPUserResizableViewAnchorPoint anchorPoint;
} CGPointSPUserResizableViewAnchorPointPair;

- (SPUserResizableViewAnchorPoint)anchorPointForTouchLocation:(CGPoint)touchPoint {
    // (1) Calculate the positions of each of the anchor points.
    CGPointSPUserResizableViewAnchorPointPair upperLeft = { CGPointMake(0.0, 0.0), SPUserResizableViewUpperLeftAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair upperMiddle = { CGPointMake(self.bounds.size.width/2, 0.0), SPUserResizableViewUpperMiddleAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair upperRight = { CGPointMake(self.bounds.size.width, 0.0), SPUserResizableViewUpperRightAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair middleRight = { CGPointMake(self.bounds.size.width, self.bounds.size.height/2), SPUserResizableViewMiddleRightAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair lowerRight = { CGPointMake(self.bounds.size.width, self.bounds.size.height), SPUserResizableViewLowerRightAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair lowerMiddle = { CGPointMake(self.bounds.size.width/2, self.bounds.size.height), SPUserResizableViewLowerMiddleAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair lowerLeft = { CGPointMake(0, self.bounds.size.height), SPUserResizableViewLowerLeftAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair middleLeft = { CGPointMake(0, self.bounds.size.height/2), SPUserResizableViewMiddleLeftAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair centerPoint = { CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2), SPUserResizableViewNoResizeAnchorPoint };
    
    // (2) Iterate over each of the anchor points and find the one closest to the user's touch.
    CGPointSPUserResizableViewAnchorPointPair allPoints[9] = { upperLeft, upperRight, lowerRight, lowerLeft, upperMiddle, lowerMiddle, middleLeft, middleRight, centerPoint };
    CGFloat smallestDistance = MAXFLOAT; CGPointSPUserResizableViewAnchorPointPair closestPoint = centerPoint;
    for (NSInteger i = 0; i < 9; i++) {
        CGFloat distance = SPDistanceBetweenTwoPoints(touchPoint, allPoints[i].point);
        if (distance < smallestDistance) {
            closestPoint = allPoints[i];
            smallestDistance = distance;
        }
    }
    return closestPoint.anchorPoint;
}

- (BOOL)isResizing {
    return (self.anchorPoint.adjustsH || self.anchorPoint.adjustsW || self.anchorPoint.adjustsX || self.anchorPoint.adjustsY);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Notify the delegate we've begun our editing session.
    // TODO
//    if (self.delegate && [self.delegate respondsToSelector:@selector(userResizableViewDidBeginEditing:)]) {
//        [self.delegate userResizableViewDidBeginEditing:self];
//    }
    

    UITouch *touch = [touches anyObject];
    self.anchorPoint = [self anchorPointForTouchLocation:[touch locationInView:self]];
    
    // When resizing, all calculations are done in the superview's coordinate space.
    self.touchStart = [touch locationInView:self.superview];
    if (![self isResizing]) {
        // When transformating, all calculations are done in the view's coordinate space.
        self.touchStart = [touch locationInView:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // TODO
    // Notify the delegate we've ended our editing session.
//    if (self.delegate && [self.delegate respondsToSelector:@selector(userResizableViewDidEndEditing:)]) {
//        [self.delegate userResizableViewDidEndEditing:self];
//    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // Notify the delegate we've ended our editing session.
//    if (self.delegate && [self.delegate respondsToSelector:@selector(userResizableViewDidEndEditing:)]) {
//        [self.delegate userResizableViewDidEndEditing:self];
//    }
}


- (void)showEditingHandles {
//    [borderView setHidden:NO];
}

- (void)hideEditingHandles {
//    [borderView setHidden:YES];
}

- (void)resizeUsingTouchLocation:(CGPoint)touchPoint {
    // (1) Update the touch point if we're outside the superview.
    if (self.preventsPositionOutsideSuperview) {
        CGRect boundingBox = [self.delegate resizableCollectionViewCellTranformationBoundingBox:self];
        
        CGFloat border = kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2;
        if (touchPoint.x < border) {
            touchPoint.x = border;
        }
        if (touchPoint.x > boundingBox.size.width - border) {
            touchPoint.x = boundingBox.size.width - border;
        }
        if (touchPoint.y < border) {
            touchPoint.y = border;
        }
        if (touchPoint.y > boundingBox.size.height - border) {
            touchPoint.y = boundingBox.size.height - border;
        }
    }
    
    // (2) Calculate the deltas using the current anchor point.
    CGFloat deltaW = self.anchorPoint.adjustsW * (self.touchStart.x - touchPoint.x);
    CGFloat deltaX = self.anchorPoint.adjustsX * (-1.0 * deltaW);
    CGFloat deltaH = self.anchorPoint.adjustsH * (touchPoint.y - self.touchStart.y);
    CGFloat deltaY = self.anchorPoint.adjustsY * (-1.0 * deltaH);
    
    // (3) Calculate the new frame.
    CGFloat newX = self.frame.origin.x + deltaX;
    CGFloat newY = self.frame.origin.y + deltaY;
    CGFloat newWidth = self.frame.size.width + deltaW;
    CGFloat newHeight = self.frame.size.height + deltaH;
    
    CGSize minSize = [self.delegate minCellSizeForResizableCollectionViewCell:self];
    // (4) If the new frame is too small, cancel the changes.
    if (newWidth < minSize.width ) {
        newWidth = self.frame.size.width;
        newX = self.frame.origin.x;
    }
    if (newHeight < minSize.height) {
        newHeight = self.frame.size.height;
        newY = self.frame.origin.y;
    }
    
    // (5) Ensure the resize won't cause the view to move offscreen.
    if (self.preventsPositionOutsideSuperview) {
        CGRect boundingBox = [self.delegate resizableCollectionViewCellTranformationBoundingBox:self];
        if ( ! CGRectIsEmpty(boundingBox) ) {
            if (newX < boundingBox.origin.x) {
                // Calculate how much to grow the width by such that the new X coordintae will align with the superview.
                deltaW = self.frame.origin.x - boundingBox.origin.x;
                newWidth = self.frame.size.width + deltaW;
                newX = boundingBox.origin.x;
            }
            if (newX + newWidth > boundingBox.origin.x + boundingBox.size.width) {
                newWidth = boundingBox.size.width - newX;
            }
            if (newY < boundingBox.origin.y) {
                // Calculate how much to grow the height by such that the new Y coordintae will align with the superview.
                deltaH = self.frame.origin.y - boundingBox.origin.y;
                newHeight = self.frame.size.height + deltaH;
                newY = boundingBox.origin.y;
            }
            if (newY + newHeight > boundingBox.origin.y + boundingBox.size.height) {
                newHeight = boundingBox.size.height - newY;
            }
            
        }
        
    }
    
    CGRect originalFrame = self.frame;
    
    self.frame = CGRectMake(newX, newY, newWidth, newHeight);;
    self.touchStart = touchPoint;
    
    [self informDelegateAboutTransformationFromOriginalFrame:originalFrame];
}

- (void)informDelegateAboutTransformationFromOriginalFrame:(CGRect)originalFrame
{
    if ( [self.delegate respondsToSelector:@selector(resizableCollectionViewCellDidTransformed:fromOriginalFrame:)] ) {
        [self.delegate resizableCollectionViewCellDidTransformed:self
                                               fromOriginalFrame:originalFrame];
    }
}

- (CGPoint)translationDeltaUsingTouchLocation:(CGPoint)touchPoint
{
    
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - self.touchStart.x, self.center.y + touchPoint.y - self.touchStart.y);
    if (self.preventsPositionOutsideSuperview) {
        
        CGRect boundingBox = [self.delegate resizableCollectionViewCellTranformationBoundingBox:self];
        
        // Ensure the translation won't cause the view to move offscreen.
        CGFloat midPointX = CGRectGetMidX(self.bounds);
        if (newCenter.x > boundingBox.size.width - midPointX) {
            newCenter.x = boundingBox.size.width - midPointX;
        }
        if (newCenter.x < midPointX) {
            newCenter.x = midPointX;
        }
        CGFloat midPointY = CGRectGetMidY(self.bounds);
        if (newCenter.y > boundingBox.size.height - midPointY) {
            newCenter.y = boundingBox.size.height - midPointY;
        }
        if (newCenter.y < midPointY) {
            newCenter.y = midPointY;
        }
    }
    
    return CGPointMake(self.center.x - newCenter.x, self.center.y - newCenter.y);
    
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint {
    
    CGPoint delta = [self translationDeltaUsingTouchLocation:touchPoint];
    CGPoint newCenter = self.center;
    newCenter.x -= delta.x;
    newCenter.y -= delta.y;
    
    CGRect originalFrame = self.frame;
    self.center = newCenter;
    
    [self informDelegateAboutTransformationFromOriginalFrame:originalFrame];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([self isResizing]) {
        
        [self resizeUsingTouchLocation:[[touches anyObject] locationInView:self.superview]];
    } else {
        
        [self translateUsingTouchLocation:[[touches anyObject] locationInView:self]];
    }
}



@end
