//
//  MGResizableCollectionViewFlowLayout.m
//  MGResizableCollectionView
//
//  Created by Maros Galik on 06/02/14.
//  Copyright Maros Galik. All rights reserved.
//

#import "MGResizableCollectionViewLayout.h"
#import "MGSize.h"

#import "MGViewController.h"

#import "MGCollectionViewLayoutConstraintRulerExpander.h"

@interface MGResizableCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *layoutAttributes;

@property id <MGCollectionViewLayoutConstraintRuler> ruler;

@end

@implementation MGResizableCollectionViewLayout

- (CGSize)minCellSize
{
    id <MGResizableCollectionViewDelegate> delegate = (id<MGResizableCollectionViewDelegate>)self.collectionView.delegate;
    if ( [delegate respondsToSelector:@selector(minCellSizeForCollectionView:layout:)] ) {
        return [delegate minCellSizeForCollectionView:self.collectionView
                                               layout:self];
    }
    
    return kMGResizableCollectionView_DefaultMinCellSize;
}

- (CGSize)standardCellSize
{
    id <MGResizableCollectionViewDelegate> delegate = (id<MGResizableCollectionViewDelegate>)self.collectionView.delegate;
    if ( [delegate respondsToSelector:@selector(standardCellSizeForCollectionView:layout:)] ) {
        return [delegate standardCellSizeForCollectionView:self.collectionView
                                                    layout:self];
    }
    
    return kMGResizableCollectionView_DefaultStandardCellSize;
}

- (NSInteger)numberOfColumns
{
    return [self collectionViewContentSize].width / [self standardCellSize].width;
}

- (void)setupLayoutBehavior
{
    // setup ruler (autoresizing/moving of the other cells)
    self.ruler = [[MGCollectionViewLayoutConstraintRulerExpander alloc] initWithConstraintCellSize:[self minCellSize]];
}

- (void)setupLayoutAttributes
{
    self.layoutAttributes = [NSMutableArray array];
    
    CGSize cellSize = [self standardCellSize];
    
    NSInteger numberOfColumns = [self numberOfColumns];
    
    CGFloat interItemSpacing = kMGResizableCollectionView_DefaultInterItemSpacing;
    
    for ( int i=0; i < [self.collectionView numberOfItemsInSection:0]; i++ )
    {
    
        // TODO: support multiple sections
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes* layoutAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        layoutAttributes.size = cellSize;
        
        NSInteger column = indexPath.item % numberOfColumns;
        
        layoutAttributes.center = CGPointMake( (column * (cellSize.width + interItemSpacing)) + (cellSize.width / 2.0),
                                               (i / numberOfColumns) * cellSize.height + (cellSize.height / 2.0) );
        
        [self.layoutAttributes addObject:layoutAttributes];

    }
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath

{
    return self.layoutAttributes[indexPath.item];
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect; // return an array layout attributes instances for all the views in the given rect
{
    if ( self.layoutAttributes == nil ) {
        [self setupLayoutBehavior];
        [self setupLayoutAttributes];
    }
    return self.layoutAttributes;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


- (CGSize)collectionViewContentSize;
{
    id <MGResizableCollectionViewDelegate> delegate = (id<MGResizableCollectionViewDelegate>)self.collectionView.delegate;
    if ( [delegate respondsToSelector:@selector(contentSizeOfResizableCollectionView:layout:)] ) {
        return [delegate contentSizeOfResizableCollectionView:self.collectionView
                                                       layout:self];

    }
    
    return kMGResizableCollectionView_DefaultContentSize;

}

- (void)resizableCollectionViewCellDidTransformed:(MGResizableCollectionViewCell*)cell
                                fromOriginalFrame:(CGRect)originalFrame
{
    NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
    
//    NSLog(@"index path item: %d; newFrameOrigin: %f %f;", indexPath.item, cell.frame.origin.x, cell.frame.origin.y);
    
    UICollectionViewLayoutAttributes *layoutAttribute = (UICollectionViewLayoutAttributes*)[self.layoutAttributes objectAtIndex:indexPath.item];

//    NSLog(@"Collection view offset: %f %f", self.collectionView.contentOffset.x, self.collectionView.contentOffset.y);
    
    layoutAttribute.frame = cell.frame;
    
    [self.ruler collectionViewLayoutAttributes:self.layoutAttributes
                        layoutAttributeMutated:layoutAttribute
                             fromOriginalFrame:(CGRect)originalFrame];
    
    [self invalidateLayout];
}

- (CGRect)resizableCollectionViewCellTranformationBoundingBox:(MGResizableCollectionViewCell*)cell
{
    return CGRectMake(self.collectionView.bounds.origin.x, self.collectionView.bounds.origin.y,
                      self.collectionView.contentSize.width, self.collectionView.contentSize.height);
}

- (CGSize)minCellSizeForResizableCollectionViewCell:(MGResizableCollectionViewCell*)cell
{
    return [self minCellSize];
}


#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return NO;
}



@end
