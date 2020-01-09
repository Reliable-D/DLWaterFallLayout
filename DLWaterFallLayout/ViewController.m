//
//  ViewController.m
//  DLWaterFallLayout
//
//  Created by 邓乐 on 2020/1/8.
//  Copyright © 2020 邓乐. All rights reserved.
//

#import "ViewController.h"
#import "DLFlowLayout.h"
#import "FLFTactLayoutListMasonryLayout.h"

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface DLLayoutCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *label;

@end

@implementation DLLayoutCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [UILabel new];
        _label.frame = CGRectMake(0, 0, 100, 20);
        [self.contentView addSubview:_label];
        self.contentView.backgroundColor = randomColor;
    }
    return self;
}

@end

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FLFTactLayoutListMasonryLayout *layout = [FLFTactLayoutListMasonryLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.pagingSection = 3;
    [layout addStickyHeaderSection:0];
    [layout addStickyHeaderSection:2];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[DLLayoutCell class] forCellWithReuseIdentifier:@"layout"];
    [self.collectionView registerClass:[DLLayoutCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[DLLayoutCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionView];
}
 
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DLLayoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"layout" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%zd/%zd",indexPath.item,indexPath.section];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DLLayoutCell *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    view.label.text = [NSString stringWithFormat:@"header %zd/%zd",indexPath.item,indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        view.hidden = YES;
    }
    return view;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(200, arc4random()%2?100:150);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(414, 44);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(414, 44);
}

@end
