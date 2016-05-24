//
//  CQShopCell.m
//  text_pubuliu
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CQShopCell.h"
#import "CQShop.h"
#import "UIImageView+WebCache.h"

@interface CQShopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation CQShopCell

- (void)setShop:(CQShop *)shop
{
    _shop = shop;
    
    // 1.图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    // 2.价格
    self.priceLabel.text = shop.price;
}
@end
