//
//  MGResizableCollectionViewCell.h
//  MGResizableCollectionView
//
//  Created by Maros Galik on 06/02/14.
//  Copyright (c) 2014 Maros Galik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGResizableCollectionViewCell;

@protocol MGResizableCollectionViewCellDelegate

@required

- (void)resizableCollectionViewCellDidTransformed:(MGResizableCollectionViewCell*)cell
                                fromOriginalFrame:(CGRect)originalFrame;

- (CGRect)resizableCollectionViewCellTranformationBoundingBox:(MGResizableCollectionViewCell*)cell;

- (CGSize)minCellSizeForResizableCollectionViewCell:(MGResizableCollectionViewCell*)cell;

@end

@interface MGResizableCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) NSObject <MGResizableCollectionViewCellDelegate>* delegate;

@property BOOL preventsPositionOutsideSuperview;

@end
