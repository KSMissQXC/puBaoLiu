//
//  ViewController.m
//  text_pubuliu
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "CQWaterFlowLayout.h"
#import "CQShopCell.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "CQShop.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,CQWaterFlowLayoutDelegate>

@property (strong, nonatomic)NSMutableArray *shopArray;
@property (weak, nonatomic)UICollectionView *collectionView;



@end

@implementation ViewController
static  NSString * const ID = @"cell";

-(NSMutableArray *)shopArray{
    if (_shopArray == nil) {
        _shopArray = [NSMutableArray array];
    }
    return _shopArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollection];
    [self setupRefresh];

    
    
}

-(void)setupRefresh{
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.header beginRefreshing];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    self.collectionView.footer.hidden = YES;

}

-(void)loadNewShops{
    NSArray *tempA = [CQShop objectArrayWithFilename:@"1.plist"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.shopArray removeAllObjects];

        [self.shopArray addObjectsFromArray:tempA];
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
        
    });
    
}

-(void)loadMoreShops{
      NSArray *tempA = [CQShop objectArrayWithFilename:@"1.plist"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.shopArray addObjectsFromArray:tempA];
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];

    });
    
    
    
}


-(void)setupCollection{
    CQWaterFlowLayout *waterLayout = [[CQWaterFlowLayout alloc]init];
    waterLayout.delegate = self;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:waterLayout];
//    [collectionView registerClass:[CQShopCell class] forCellWithReuseIdentifier:ID];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CQShopCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
}

#pragma mark - 代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.collectionView.footer.hidden = !self.shopArray.count;
    return self.shopArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CQShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.shop = self.shopArray[indexPath.item];
    return cell;
 
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 0;
//}
-(CGFloat)waterFlowLayout:(CQWaterFlowLayout *)waterFlowLayout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth{
    CQShop *shop = self.shopArray[index];
    return itemWidth * shop.h / shop.w;

}

-(NSInteger)columnCountInWaterFlowLayout:(CQWaterFlowLayout *)waterFlowLayout{
    return 3;
}

//-(UIEdgeInsets)edgeInsetsInWaterFlowLayout:(CQWaterFlowLayout *)waterFlowLayout{
//    return UIEdgeInsetsMake(20, 30, 30, 20);
//}









@end
