//
//  MGResizableCollectionView.h
//  MGResizableCollectionView
//
//  Created by Maros Galik on 07/02/14.
//  Copyright (c) 2014 Maros Galik. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGResizableCollectionViewLayout.h"

@interface MGResizableCollectionView : UICollectionView

@property (nonatomic, assign) id <MGResizableCollectionViewDelegate> delegate;

@end
