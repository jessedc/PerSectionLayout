//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

@import UIKit;
@class AMPerSectionCollectionViewLayout;

extern NSString * const AMPerSectionCollectionElementKindHeader;
extern NSString * const AMPerSectionCollectionElementKindFooter;
extern NSString * const AMPerSectionCollectionElementKindSectionHeader;
extern NSString * const AMPerSectionCollectionElementKindSectionFooter;

@protocol AMPerSectionCollectionViewLayoutDelegate <UICollectionViewDelegate>
@optional
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForHeaderInLayout:(AMPerSectionCollectionViewLayout *)collectionViewLayout;
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForFooterInLayout:(AMPerSectionCollectionViewLayout *)collectionViewLayout;
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout hasStickyHeaderOverSection:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForHeaderInSection:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout sizeForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout minimumWidthForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(AMPerSectionCollectionViewLayout *)collectionViewLayout isSectionStickyAtIndex:(NSInteger)section;
@end

@interface AMPerSectionCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) CGSize itemSize; // default: (50, 50)
@property (nonatomic, assign) CGSize headerReferenceSize; // default: CGSizeZero
@property (nonatomic, assign) CGSize footerReferenceSize; // default: CGSizeZero
@property (nonatomic, assign, getter = hasStickyHeader) BOOL stickyHeader; // default: NO
@property (nonatomic, assign) CGSize sectionHeaderReferenceSize; // default: CGSizeZero
@property (nonatomic, assign) CGSize sectionFooterReferenceSize; // default: CGSizeZero
@property (nonatomic, assign) UIEdgeInsets sectionInset; // default: UIEdgeInsetsZero
@property (nonatomic, assign) CGFloat sectionMinimumWidth; // default: NAN (use the collection view width)
@property (nonatomic, assign) CGFloat minimumLineSpacing; // default: 5
@property (nonatomic, assign) CGFloat minimumInteritemSpacing; // default: 5

@end
