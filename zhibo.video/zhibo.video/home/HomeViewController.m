//
//  HomeViewController.m
//  zhibo.video
//
//  Created by kkqb on 2017/3/14.
//  Copyright © 2017年 swift_wach. All rights reserved.
//

#import "HomeViewController.h"
#import "homeCollectionViewCell.h"
#import "HomeModel.h"

#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "PlayVideoViewController.h"


@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) UICollectionView *mycollectView;

@property (nonatomic , strong) NSMutableArray *dataArrays;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"主页";
    
    self.dataArrays = [NSMutableArray new];
    
    [self setUI];
    
    [self getData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.mycollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    
    self.mycollectView.backgroundColor = [UIColor lightGrayColor];
    self.mycollectView.delegate = self;
    self.mycollectView.dataSource = self;
    
    [self.mycollectView registerNib:[UINib nibWithNibName:@"homeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"COLLECTVIEW"];
    [self.view addSubview:self.mycollectView];
}
- (void) getData{
    // 映客数据url
    NSString *urlStr = @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1";
    
    // 请求数据
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [mgr GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *lives = responseObject[@"lives"];
        for (NSDictionary *dict in lives) {
            HomeModel *model = [[HomeModel alloc] init];
            model.imageUrl = dict[@"creator"][@"portrait"];
            model.stream_addr = dict[@"stream_addr"];
            model.name = dict[@"creator"][@"nick"];
            [self.dataArrays addObject:model];
        }
        [self.mycollectView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArrays.count;
}
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    homeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"COLLECTVIEW" forIndexPath:indexPath];
    HomeModel *model = self.dataArrays[indexPath.row];
    [cell.iconimageView setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    cell.iconName.text = model.name;
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PlayVideoViewController *VC = [[PlayVideoViewController alloc] init];
    HomeModel *model = self.dataArrays[indexPath.row];
    VC.stream_addr = model.stream_addr;
    VC.name = model.name;
    VC.imageUrl = model.imageUrl;
    [self.navigationController pushViewController:VC animated:YES];
}
//返回每一个item的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 50)/2, 300);
}

//返回每一组的item离上下左右的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
