//
//  DLFlowLayout.h
//  DLWaterFallLayout
//
//  Created by 邓乐 on 2020/1/8.
//  Copyright © 2020 邓乐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DLFlowLayout ;
//1.定义协议
@protocol WaterFallLayoutDelegate<NSObject>
//必须实现的方法
@required
/**
 每一列的宽度
 */
- (CGFloat)waterFallLayout:(DLFlowLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth ;

//可选
@optional
/**
 一共有多少列
 */
-(NSInteger)columnCountWaterFallLayout:(DLFlowLayout *)waterFallLayout ;
/**
 每一列的间距
 */
-(CGFloat)columnMarginWaterFallLayout:(DLFlowLayout *)waterFallLayout ;
/**
 每一行的间距
 */
-(CGFloat)rowMarginWaterFallLayout:(DLFlowLayout *)waterFallLayout ;
/**
 每一个Item的内间距
 */
-(UIEdgeInsets)edgeInsetsInWaterFallLayout:(DLFlowLayout *)waterFallLayout ;

@end

@interface DLFlowLayout : UICollectionViewLayout

- (NSUInteger)colunmCount;
- (CGFloat)columnMargin;
- (CGFloat)rowMargin;
- (UIEdgeInsets)edgeInsets;

//2.声明代理属性
@property(nonatomic,weak) id<WaterFallLayoutDelegate> delegate ;

@end

NS_ASSUME_NONNULL_END
