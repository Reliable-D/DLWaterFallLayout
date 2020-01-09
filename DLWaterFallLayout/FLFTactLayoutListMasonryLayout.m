//
//  FLFTactLayoutListMasonryLayout.m
//  DLWaterFallLayout
//
//  Created by 邓乐 on 2020/1/9.
//  Copyright © 2020 邓乐. All rights reserved.
//

#import "FLFTactLayoutListMasonryLayout.h"

@interface FLFTactLayoutListMasonryLayout ()
{
    NSMutableIndexSet *m_sectionsWithStickyHeader;
}

@property (strong, nonatomic) NSMutableArray *itemAttributes;
/**
 item 的高度数组
 */
@property (nonatomic, copy) NSArray<NSNumber *> *arrItemHeight;

/**
 cell 布局属性集
 */
@property (nonatomic, strong) NSArray<UICollectionViewLayoutAttributes *> *arrAttributes;


@end

@implementation FLFTactLayoutListMasonryLayout

@synthesize exclusiveStickyHeader = m_exclusiveStickyHeader;
@synthesize horizontalPagingOffset = m_horizontalPagingOffset;
@synthesize pagingSection = m_pagingSection;

- (instancetype)init
{
    if (self = [super init])
    {
        m_pagingSection = NSNotFound;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        m_pagingSection = NSNotFound;
    }
    
    return self;
}

- (void)addStickyHeaderSection:(NSUInteger)section
{
    if (nil == m_sectionsWithStickyHeader)
    {
        m_sectionsWithStickyHeader = [[NSMutableIndexSet alloc] initWithIndex:section];
    }
    else
    {
        [m_sectionsWithStickyHeader addIndex:section];
    }
}

- (void)removeStickyHeaderSection:(NSUInteger)section
{
    if (nil != m_sectionsWithStickyHeader)
    {
        [m_sectionsWithStickyHeader removeIndex:section];
        // self invalidate
    }
}

- (void)removeAllStickyHeader
{
    if (nil != m_sectionsWithStickyHeader)
    {
        [m_sectionsWithStickyHeader removeAllIndexes];
    }
}

- (BOOL)containStickyHeaderSection:(NSUInteger)section
{
    if (nil != m_sectionsWithStickyHeader)
    {
        return [m_sectionsWithStickyHeader containsIndex:section];
    }
    return NO;
}

- (void)setHorizontalPagingOffset:(CGFloat)horizontalPagingOffset
{
    m_horizontalPagingOffset = horizontalPagingOffset;
    
    [self invalidateLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
    
    // return YES;
}

- (void)prepareLayout
{
    [super prepareLayout];
    // item 数量为零不做处理
     if ([self.arrItemHeight count] == 0) {
         
         return;
     }
     
     // 计算一行可以放多少个项
     NSInteger nItemInRow = (self.collectionViewContentSize.width - self.sectionInset.left - self.sectionInset.right + self.minimumInteritemSpacing) / (self.itemSize.width + self.minimumInteritemSpacing);
     // 对列的长度进行累计
     NSMutableArray *arrmColumnLength = [NSMutableArray arrayWithCapacity:100];
     for (NSInteger i = 0; i < nItemInRow; i++) {
         
         [arrmColumnLength addObject:@0];
     }
     
     NSMutableArray *arrmTemp = [NSMutableArray arrayWithCapacity:100];
     // 遍历设置每一个item的布局
     for (NSInteger i = 0; i < [self.arrItemHeight count]; i++) {
         
         // 设置每个item的位置等相关属性
         NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
         // 创建每一个布局属性类，通过indexPath来创建
         UICollectionViewLayoutAttributes *attris = [self layoutAttributesForItemAtIndexPath:index];
         CGRect recFrame = attris.frame;
         // 有数组得到的高度
         recFrame.size.height = [self.arrItemHeight[i] doubleValue];
         // 最短列序号
         NSInteger nNumShort = 0;
         // 最短的长度
         CGFloat fShortLength = [arrmColumnLength[0] doubleValue];
         // 比较是否存在更短的列
         for (int i = 1; i < [arrmColumnLength count]; i++) {

             CGFloat fLength = [arrmColumnLength[i] doubleValue];
             if (fLength < fShortLength) {

                 nNumShort = i;
                 fShortLength = fLength;
             }
         }
         // 插入到最短的列中
         recFrame.origin.x = self.sectionInset.left + (self.itemSize.width + self.minimumInteritemSpacing) * nNumShort;
         recFrame.origin.y = fShortLength + self.minimumLineSpacing;
         // 更新列的累计长度
         arrmColumnLength[nNumShort] = [NSNumber numberWithDouble:CGRectGetMaxY(recFrame)];
         
         // 更新布局
         attris.frame = recFrame;
         [arrmTemp addObject:attris];
     }
     self.arrAttributes = arrmTemp;
     
     // 因为使用了瀑布流布局使得滚动范围是根据 item 的大小和个数决定的，所以以最长的列为基准，将高度平均到每一个 cell 中
     // 最长列序号
     NSInteger nNumLong = 0;
     // 最长的长度
     CGFloat fLongLength = [arrmColumnLength[0] doubleValue];
     // 比较是否存在更短的列
     for (int i = 1; i < [arrmColumnLength count]; i++) {

         CGFloat fLength = [arrmColumnLength[i] doubleValue];
         if (fLength > fLongLength) {

             nNumLong = i;
             fLongLength = fLength;
         }
     }
     // 在大小一样的情况下，有多少行
     NSInteger nRows = ([self.arrItemHeight count] + nItemInRow - 1) / nItemInRow;
     self.itemSize = CGSizeMake(self.itemSize.width, (fLongLength + self.minimumLineSpacing) / nRows - self.minimumLineSpacing);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect].mutableCopy;
    __block NSMutableArray<UICollectionViewLayoutAttributes *> *newAttributes = [[NSMutableArray<UICollectionViewLayoutAttributes *> alloc] init];
    NSUInteger maxSection = 0;
    NSUInteger minSection = 0;
    __block NSMutableDictionary<NSNumber *, UICollectionViewLayoutAttributes *> *headerAttributes = nil;
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in attributes)
    {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        
        /**< make sure each section only add decoration view layout attributes once */
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell)
        {
            if (indexPath.item == 0 && [self.collectionView numberOfItemsInSection:indexPath.section] > 0)
            {
                // UICollectionViewLayoutAttributes *temp = [self layoutAttributesForDecorationViewOfKind:kDecorationViewKind atIndexPath:indexPath];
                
                // [newAttributes addObject:temp];
            }
            
            // PagingSection
            if (m_pagingSection <= indexPath.section)
            {
                CGPoint origin = layoutAttributes.frame.origin;
                layoutAttributes.frame = (CGRect){
                    .origin = CGPointMake(origin.x - m_horizontalPagingOffset, origin.y),
                    .size = layoutAttributes.frame.size
                };
            }
        }
        
        if (nil != m_sectionsWithStickyHeader && m_sectionsWithStickyHeader.count > 0)
        {
            if ([m_sectionsWithStickyHeader containsIndex: layoutAttributes.indexPath.section])
            {
                if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
                {
                    if (nil == headerAttributes) headerAttributes = [[NSMutableDictionary<NSNumber *, UICollectionViewLayoutAttributes *> alloc] initWithCapacity:m_sectionsWithStickyHeader.count];
                    
                    [headerAttributes setObject:layoutAttributes forKey:[NSNumber numberWithUnsignedInteger:layoutAttributes.indexPath.section]];
                }
            }
            if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell)
            {
                if (layoutAttributes.indexPath.section > maxSection)
                {
                    maxSection = layoutAttributes.indexPath.section;
                }
                if (layoutAttributes.indexPath.section < minSection)
                {
                    minSection = layoutAttributes.indexPath.section;
                }
            }
        }
    }
    
    if (nil != m_sectionsWithStickyHeader && m_sectionsWithStickyHeader.count > 0)
    {
        UICollectionView * const cv = self.collectionView;
        CGPoint const contentOffset = cv.contentOffset;
        
        __block float totalHeaderHeight = 0; // only for handleStickyHeader
        BOOL exclusiveStickyHeader = m_exclusiveStickyHeader;
        [m_sectionsWithStickyHeader enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
         {
             if (idx > maxSection)
             {
                 *stop = YES;   // break
                 return;
             }
             if (exclusiveStickyHeader && idx < minSection)
             {
                 return; // continue
             }
             
             UICollectionViewLayoutAttributes *layoutAttributes = nil;
             if (nil != headerAttributes)
             {
                 layoutAttributes = [headerAttributes objectForKey:[NSNumber numberWithUnsignedInteger:idx]];
             }
             
             if (nil == layoutAttributes)
             {
                 NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
                 layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
                 if (CGSizeEqualToSize(layoutAttributes.size, CGSizeZero))
                 {
                     return;
                 }
                 
                 [newAttributes addObject:layoutAttributes];
             }
             
             NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:idx];
             CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
             CGFloat firstCellTop = CGRectGetMaxY(layoutAttributes.frame);
             CGFloat lastCellBottom = firstCellTop;
             
             if (exclusiveStickyHeader)
             {
                 CGPoint origin = layoutAttributes.frame.origin;
                 if (numberOfItemsInSection > 0)
                 {
                     NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
                     NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:idx];
                     UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
                     UICollectionViewLayoutAttributes *lastCellAttrs = [self layoutAttributesForItemAtIndexPath:lastCellIndexPath];
                     
                     firstCellTop = CGRectGetMinY(firstCellAttrs.frame);
                     lastCellBottom = CGRectGetMaxY(lastCellAttrs.frame);
                 }
                 
                 CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
                 origin.y = MIN(
                                MAX(
                                    contentOffset.y,
                                    (firstCellTop - headerHeight)
                                    ),
                                (lastCellBottom - headerHeight)
                                );
                 
                 layoutAttributes.frame = (CGRect){
                     .origin = CGPointMake(origin.x, origin.y),
                     .size = layoutAttributes.frame.size
                 };
                 
             }
             else
             {
                 CGPoint origin = layoutAttributes.frame.origin;
                 origin.y = MAX(
                                contentOffset.y + totalHeaderHeight,
                                origin.y
                                );
                 
                 layoutAttributes.frame = (CGRect){
                     .origin = CGPointMake(origin.x, origin.y),
                     .size = layoutAttributes.frame.size
                 };
             }
             
             layoutAttributes.zIndex = 1024 + idx;
             
             totalHeaderHeight += headerHeight;
             
         }];
    }
    
    [attributes addObjectsFromArray:newAttributes];
    return attributes;
}

@end
