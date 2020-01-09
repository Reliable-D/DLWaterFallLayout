//
//  FLFTactLayoutListFlowLayout.h
//  Fanli
//
//  Created by Wang Dacheng on 2019/10/23.
//  Copyright © 2019 www.fanli.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLFTactLayoutListFlowLayout : UICollectionViewFlowLayout

// exclusiveStickyHeader=YES: if there are multiple sticky headers added, only one header can be sticky at one time
@property (nonatomic, assign) BOOL exclusiveStickyHeader;
@property (nonatomic, assign) NSUInteger pagingSection;

@property (nonatomic, assign) CGFloat horizontalPagingOffset;

- (void)addStickyHeaderSection:(NSUInteger)section;
- (void)removeStickyHeaderSection:(NSUInteger)section;
- (void)removeAllStickyHeader;
- (BOOL)containStickyHeaderSection:(NSUInteger)section;

@end

NS_ASSUME_NONNULL_END
