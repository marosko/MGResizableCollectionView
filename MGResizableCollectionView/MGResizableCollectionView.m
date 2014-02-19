//
//  MGResizableCollectionView.m
//  MGResizableCollectionView
//
//  Created by Maros Galik on 07/02/14.
//  Copyright (c) 2014 Maros Galik. All rights reserved.
//

#import "MGResizableCollectionView.h"

@implementation MGResizableCollectionView

@dynamic delegate;

- (BOOL)touchesShouldCancelInContentView:(UIView *)view;
{
    return NO;
}

@end
