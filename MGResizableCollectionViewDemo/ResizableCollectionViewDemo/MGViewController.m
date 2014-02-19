//
//  MGViewController.m
//  ResizableCollectionViewDemo
//
//  Created by Maros on 2/19/14.
//  Copyright (c) 2014 Maros Galik. All rights reserved.
//

#import "MGViewController.h"

#import "MGResizableCollectionViewCell.h"

@interface MGViewController ()

@end

@implementation MGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.collectionView registerClass:[MGResizableCollectionViewCell class]
            forCellWithReuseIdentifier:@"ResizableCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MGResizableCollectionViewCell *resizableCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ResizableCell" forIndexPath:indexPath];
    
    if ( ! [self.collectionView.collectionViewLayout conformsToProtocol:@protocol(MGResizableCollectionViewCellDelegate)]) {
        NSAssert(NO, @"collectionView's custom layout must conforms to protocol an instance of %@", NSStringFromProtocol(@protocol(MGResizableCollectionViewCellDelegate)) );
    }
    
    // "random" color
    CGFloat indexAddition = (indexPath.item * 0.05);
    if ( indexAddition > 1 ) {
        indexAddition -= ((int)indexAddition);
    }
    
    
    CGFloat hue = ( 0.2 + indexAddition );  //  0.0 to 1.0
    CGFloat saturation =  ( 0.1 + indexAddition );  //  0.5 to 1.0, away from white
    CGFloat brightness =  ( 0.5 + indexAddition * ( indexPath.item % 2) );  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    resizableCell.delegate = (NSObject <MGResizableCollectionViewCellDelegate>*)self.collectionView.collectionViewLayout;
    resizableCell.backgroundColor = color;
    
    
    return resizableCell;
}

#pragma mark - MGResizableCollectionViewDelegate


- (CGSize)minCellSizeForCollectionView:(UICollectionView*)aCollectionView
                                layout:(UICollectionViewLayout*)aCollectionViewLayout
{
    return CGSizeMake(100, 100);
}

- (CGSize)standardCellSizeForCollectionView:(UICollectionView*)aCollectionView
                                     layout:(UICollectionViewLayout*)aCollectionViewLayout
{
    return CGSizeMake(200, 200);
}

- (CGSize)contentSizeOfResizableCollectionView:(UICollectionView*)aCollectionView
                                        layout:(UICollectionViewLayout*)aCollectionViewLayout
{
    return CGSizeMake(768, 2000);
}

@end
