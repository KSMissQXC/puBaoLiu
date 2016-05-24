//
//  CQWaterFlowLayout.h
//  text_pubuliu
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CQWaterFlowLayout;
@protocol CQWaterFlowLayoutDelegate <NSObject>
@required
-(CGFloat)waterFlowLayout:(CQWaterFlowLayout *)waterFlowLayout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth;

@optional
-(NSInteger)columnCountInWaterFlowLayout:(CQWaterFlowLayout *)waterFlowLayout;
-(CGFloat)columnMarginInWaterFlowLayout:(CQWaterFlowLayout *)waterFlowLayout;
-(CGFloat)rowMarginInWaterFlowLayout:(CQWaterFlowLayout *)waterFlowLayout;
-(UIEdgeInsets)edgeInsetsInWaterFlowLayout:(CQWaterFlowLayout *)waterFlowLayout;


@end

@interface CQWaterFlowLayout : UICollectionViewLayout
@property (weak, nonatomic)id<CQWaterFlowLayoutDelegate> delegate;


@end
