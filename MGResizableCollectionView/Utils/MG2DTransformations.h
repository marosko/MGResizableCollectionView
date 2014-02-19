//
//  MG2DTransformations.h
//  MGResizableCollectionView
//
//  Created by Maros Galik on 2/13/14.
//  Copyright (c) 2014 Maros Galik. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MGDirection) {
    MGDirectionUndefined = 0,
    MGDirectionUp        = 1,
    MGDirectionRight     = 1 << 1,
    MGDirectionDown      = 1 << 2,
    MGDirectionLeft      = 1 << 3,
};

@interface MG2DTransformations : NSObject

// applied for transformation
+ (MGDirection)directionOfTransformationFromRect:(CGRect)originalRect
                               toTransformedRect:(CGRect)transformedRect;

+ (MGDirection)positionOfRect:(CGRect)rectA
                       toRect:(CGRect)rectB;

@end
