//
//  MGResizableCollectionViewFlowLayout.h
//  MGResizableCollectionView
//
//  Created by Maros Galik on 06/02/14.
//  Copyright (c) 2014 Maros Galik. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGResizableCollectionViewCell.h"

// minimum size to which a cell could be resized
#define kMGResizableCollectionView_DefaultMinCellSize     CGSizeMake(100., 100.)

// standard cell size by which a cell is initialized
#define kMGResizableCollectionView_DefaultStandardCellSize     CGSizeMake(200., 200.)

// TODO: move to the delegate
// space between cells
#define kMGResizableCollectionView_DefaultInterItemSpacing   10.

// collection view content size - bounding box of where cells can be moved
#define kMGResizableCollectionView_DefaultContentSize  CGSizeMake(768, 2000)

@protocol MGResizableCollectionViewDelegate <UICollectionViewDelegate>

@optional

- (CGSize)minCellSizeForCollectionView:(UICollectionView*)aCollectionView
                                layout:(UICollectionViewLayout*)aCollectionViewLayout;

- (CGSize)standardCellSizeForCollectionView:(UICollectionView*)aCollectionView
                                     layout:(UICollectionViewLayout*)aCollectionViewLayout;

- (CGSize)contentSizeOfResizableCollectionView:(UICollectionView*)aCollectionView
                                        layout:(UICollectionViewLayout*)aCollectionViewLayout;

@end

@interface MGResizableCollectionViewLayout : UICollectionViewLayout <MGResizableCollectionViewCellDelegate>

@end
