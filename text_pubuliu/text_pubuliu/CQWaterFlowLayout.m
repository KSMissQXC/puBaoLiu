//
//  CQWaterFlowLayout.m
//  text_pubuliu
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CQWaterFlowLayout.h"
/** 默认的列数 */
static const NSInteger CQDefaultColumnCount = 3;
/** 每一列之间间距 */
static const CGFloat CQDefaultColumnMargin = 10;
/** 每一列之间间距 */
static const CGFloat CQDefaultRowMargin = 10;
/** 边缘间距 */
static const UIEdgeInsets CQDefaultEdgeInsets = {10,10,10,10};

@interface CQWaterFlowLayout ()


@property (strong, nonatomic)NSMutableArray *columnHeights;

@property (strong, nonatomic)NSMutableArray *attrsArray;

@property (assign, nonatomic)CGFloat maxHeight;




-(NSInteger)columnCount;
-(CGFloat)columnMargin;
-(CGFloat)rowMargin;
-(UIEdgeInsets)edgeInset;



@end

@implementation CQWaterFlowLayout

#pragma mark - 懒加载
-(NSMutableArray *)columnHeights{
    if (_columnHeights == nil) {
        _columnHeights = [NSMutableArray array];
        for (NSInteger i = 0; i < CQDefaultColumnCount; i++) {
            [_columnHeights addObject:@(CQDefaultEdgeInsets.top)];
        }
    }
    return _columnHeights;
}

-(NSMutableArray *)attrsArray{
    if (_attrsArray == nil) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

-(NSInteger)columnCount{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterFlowLayout:)]) {
        return [self.delegate columnCountInWaterFlowLayout:self];
    }else{
        return CQDefaultColumnCount;
    }
}

-(CGFloat)columnMargin{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterFlowLayout:)]) {
        return [self.delegate columnMarginInWaterFlowLayout:self];
    }else{
        return CQDefaultColumnMargin;
    }
}

-(CGFloat)rowMargin{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterFlowLayout:)]) {
        return [self.delegate rowMarginInWaterFlowLayout:self];
    }else{
        return CQDefaultRowMargin;
    }
}

-(UIEdgeInsets)edgeInset{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterFlowLayout:)]) {
        return [self.delegate edgeInsetsInWaterFlowLayout:self];
    }else{
        return CQDefaultEdgeInsets;
    }
}





//初始化布局,会调用一次
- (void)prepareLayout{
    
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInset.top)];
    }
    [self.attrsArray removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
        
    }

}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArray;
}

- (CGSize)collectionViewContentSize{
    return CGSizeMake(0, self.maxHeight + self.edgeInset.bottom);
}


- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //collentionView宽度
    CGFloat collectionW = self.collectionView.frame.size.width;
    
    //item宽度
    CGFloat itemW = (collectionW - self.edgeInset.left - self.edgeInset.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    CGFloat itemH = [self.delegate waterFlowLayout:self heightForItemAtIndex:indexPath.item itemWidth:itemW];
    NSUInteger destColumn = 0;
    CGFloat minHeight = [self.columnHeights[destColumn] floatValue];
    self.maxHeight = minHeight;
    for (NSInteger i = 1; i < self.columnHeights.count; i++) {
        //找出最短列
        CGFloat currentHeight = [self.columnHeights[i] floatValue];
        if (minHeight > currentHeight) {
            minHeight = currentHeight;
            destColumn = i;
        }
        
        if (self.maxHeight < currentHeight) {
            self.maxHeight = currentHeight;
        }
    }
   
    CGFloat itemX = destColumn  * (itemW + self.columnMargin) + CQDefaultEdgeInsets.left;
    CGFloat itemY = minHeight;

    if (itemY != CQDefaultEdgeInsets.top) {
        itemY += self.rowMargin;
    }
    attrs.frame = CGRectMake(itemX, itemY, itemW, itemH);
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    self.maxHeight = (self.maxHeight > [self.columnHeights[destColumn] floatValue]) ? self.maxHeight : [self.columnHeights[destColumn] floatValue];
    
    return attrs;
 
}













@end
