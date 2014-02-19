//
//  MGCVLayoutConstraintRulerExpander.h
//  MGResizableCollectionView
//
//  Created by Maros Galik on 2/11/14.
//  Copyright (c) 2014 Maros Galik. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGCollectionViewLayoutConstraintRuler.h"

@interface MGCollectionViewLayoutConstraintRulerExpander : NSObject <MGCollectionViewLayoutConstraintRuler>

- (id)initWithConstraintCellSize:(CGSize)minCellSize;

@property (nonatomic) CGSize minSize;

@end
