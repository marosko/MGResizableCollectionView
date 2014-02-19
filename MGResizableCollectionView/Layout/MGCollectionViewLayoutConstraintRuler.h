//
//  MGCollectionViewLayoutConstraintRuler.h
//  MGResizableCollectionView
//
//  Created by Maros Galik on 2/11/14.
//  Copyright (c) 2014 Maros Galik. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGCollectionViewLayoutConstraintRuler

- (BOOL)collectionViewLayoutAttributes:(NSArray*)layoutAttributes
                layoutAttributeMutated:(UICollectionViewLayoutAttributes*)layoutAttributeMutated
                     fromOriginalFrame:(CGRect)originalFrame;

@end
