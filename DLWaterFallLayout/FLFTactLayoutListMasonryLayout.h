//
//  FLFTactLayoutListMasonryLayout.h
//  DLWaterFallLayout
//
//  Created by 邓乐 on 2020/1/9.
//  Copyright © 2020 邓乐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLFTactLayoutListMasonryLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) BOOL exclusiveStickyHeader;
@property (nonatomic, assign) NSUInteger pagingSection;

@property (nonatomic, assign) CGFloat horizontalPagingOffset;

- (void)addStickyHeaderSection:(NSUInteger)section;
- (void)removeStickyHeaderSection:(NSUInteger)section;
- (void)removeAllStickyHeader;
- (BOOL)containStickyHeaderSection:(NSUInteger)section;

@end

NS_ASSUME_NONNULL_END
