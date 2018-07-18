//
//  ResultDetialController.m
//  JYVivoUI2
//
//  Created by jock li on 16/5/2.
//  Copyright © 2016年 timedge. All rights reserved.
//

#import "JYVivoUI2.h"
#import "ResultDetialController.h"
#import "UIResultItemLabel.h"
#import "o_ResponseMode.h"
#import "idCardAdoptMode.h"


// 返回信息中对特定照片的命名
const NSString* SelfPhotoName = @"现场照";
const NSString* IDPhotoName = @"证件照";
const NSString* LivePhotoName = @"活体检测";
const NSString* LibPhotoName = @"库里照";

@interface ResultDetialController () <UIScrollViewDelegate>
{
    NSUInteger _resultTitleCount;
}

@property (weak, nonatomic) UIPageControl *pageControl;  //滑动的点
@property (weak, nonatomic) UIScrollView *pageScrollView;//浏览照片的view
@property (weak, nonatomic) UIScrollView *resultsScrollView;

@property (weak,nonatomic) UILabel *detailsLabel;//显示详情的label

//重新开始按钮属性
@property (strong, nonatomic) UIButton *restartBtn;


//两个按钮
@property (nonatomic,weak) UIButton *resultBtn;
@property (nonatomic,weak) UIView *resultView;
@property (nonatomic,weak) UIButton *photoBtn;
@property (nonatomic,weak) UIView *photoView;


@property (nonatomic,weak) UIView *bigView;


@end

@implementation ResultDetialController

//返回按钮方法
- (void)backBtn
{

    [self dismissViewControllerAnimated:YES completion:nil];
}


//重新开始按钮方法
- (void)reStart
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (UIImage *)imageOrientation:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation)
    {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newPic;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ////////////////
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,20)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 60)];
    titleLabel.textAlignment = NSTextAlignmentCenter;//居中显示
    titleLabel.text = @"结果详情";
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.textColor = [UIColor colorWithRed:138/255.0 green:240/255.0 blue:249/255.0 alpha:1];
    titleLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    //返回键
    UIButton *reButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 60)];
    [self.view addSubview:reButton];
    [reButton setImage:[UIImage imageNamed:@"BackWhite"] forState:UIControlStateNormal];
    [reButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchDown];
    
    
    
    //两个按钮
    //结果
    UIButton *resultBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, titleLabel.frame.origin.y + titleLabel.frame.size.height + 50, self.view.frame.size.width/2 - (20*2), 30)];
    [resultBtn setTitle:@"结果" forState:UIControlStateNormal];
    [resultBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [resultBtn addTarget:self action:@selector(touchResult) forControlEvents:UIControlEventTouchDown];
    self.resultBtn = resultBtn;
    
    UIView *resultView = [[UIView alloc] initWithFrame:CGRectMake(resultBtn.frame.origin.x, resultBtn.frame.origin.y + resultBtn.frame.size.height -5 , resultBtn.frame.size.width, 5)];
    resultView.backgroundColor = [UIColor colorWithRed:0 green:108/255.0 blue:181/255.0 alpha:1];
    self.resultView = resultView;
    [self.view addSubview:resultView];
    [self.view addSubview:resultBtn];
    
    
    //照片
    UIButton *photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 20, titleLabel.frame.origin.y + titleLabel.frame.size.height + 50, self.view.frame.size.width/2 - (20*2), 30)];
    [photoBtn setTitle:@"照片" forState:UIControlStateNormal];
    [photoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(touchPhoto) forControlEvents:UIControlEventTouchDown];
    self.photoBtn = photoBtn;
    
    UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(photoBtn.frame.origin.x, photoBtn.frame.origin.y + photoBtn.frame.size.height -5 , photoBtn.frame.size.width, 5)];
    photoView.backgroundColor = [UIColor grayColor];
    self.photoView = photoView;
    [self.view addSubview:photoView];
    [self.view addSubview:photoBtn];
    
    
    //显示照片的ScrollView(点击照片按钮后显示)
    UIScrollView *pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 240)/2 , (self.view.frame.size.height - resultView.frame.origin.y-340)/2 - 37  + resultView.frame.origin.y, 240, 340)];
    self.pageScrollView = pageScrollView;
    pageScrollView.delegate = self;
    [self.view addSubview:pageScrollView];
    pageScrollView.alpha = 0;
    
    //滑动的点
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 240)/2, pageScrollView.frame.origin.y+pageScrollView.frame.size.height, 240, 37)];
    self.pageControl = pageControl;
    [self.view addSubview:pageControl];
    pageControl.alpha = 0;
    self.pageControl.numberOfPages = 0;
    
    //文字
    UIScrollView *resultsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(pageScrollView.frame.origin.x, pageControl.frame.origin.y + pageControl.frame.size.height, pageScrollView.frame.size.width, 40)];
    self.resultsScrollView = resultsScrollView;
    [self.view addSubview:resultsScrollView];
    
    
    //重新开始按钮
    UIButton *restartBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, self.view.frame.size.height - 80, 100, 35)];
    self.restartBtn = restartBtn;
    [restartBtn setTitle:@"重新开始" forState:UIControlStateNormal];
    [restartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [restartBtn setBackgroundColor:[UIColor colorWithRed:254/255.0 green:195/255.0 blue:97/255.0 alpha:1]];
    [restartBtn addTarget:self action:@selector(reStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:restartBtn];
    
    
    //现实l1 l2 l3的View
    UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - resultView.frame.origin.y-340)/2 + resultView.frame.origin.y, self.view.frame.size.width, 340)];
    self.bigView = bigView;
    [self.view addSubview:bigView];
    bigView.alpha = 1;
    
    
    // 生成图片信息
    idCardAdoptMode *iAMode =[[idCardAdoptMode alloc] init];
    
    [self addPhotoToScrollbar:[UIImage imageWithCGImage:iAMode.idCardImage.CGImage scale:1 orientation:UIImageOrientationLeft] withLabel:[IDPhotoName copy]];
    
    [self addPhotoToScrollbar:[UIImage imageWithCGImage:[UIImage imageWithData:iAMode.selfData].CGImage scale:1 orientation:UIImageOrientationUp] withLabel:[SelfPhotoName copy]];
    
    for (NSUInteger i=0; i<iAMode.photos.count; i++)
    {
        
        [self addPhotoToScrollbar:[iAMode.photos objectAtIndex:i] withLabel:[[NSString alloc]initWithFormat:@"活体照%ld", i+1]];
    }
    
    // 按结果代码生成结果标签

    for (int i=0; i<iAMode.resultInfos.count; i++)
    {
        o_ResponseMode *mode = [iAMode.resultInfos objectAtIndex:i];
        
        if (mode.o_responseNumber == 1)
        {
            [self addResultTitle:[[NSString alloc]initWithFormat:@"1:%@", [mode.o_response objectForKey:@"info"]] by:([[mode.o_response objectForKey:@"code"] intValue] == 0)];
        }
        else if(mode.o_responseNumber == 2)
        {
            [self addResultTitle:[[NSString alloc]initWithFormat:@"2:%@", [mode.o_response objectForKey:@"info"]] by:([[mode.o_response objectForKey:@"code"] intValue] == 0)];
        }
        else if(mode.o_responseNumber == 3)
        {
            [self addResultTitle:[[NSString alloc]initWithFormat:@"3:%@", [mode.o_response objectForKey:@"info"]] by:([[mode.o_response objectForKey:@"code"] intValue] == 0)];
        }
    }
    if (self.detailsLabel==nil&&iAMode.resultInfos.count==0&&iAMode.info!= nil)
    {
        UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.pageScrollView.frame.origin.y+(self.pageScrollView.frame.size.height/2), self.view.frame.size.width, 50)];
        
        detailsLabel.textColor = [UIColor redColor];
        detailsLabel.textAlignment = NSTextAlignmentCenter;//居中显示
        detailsLabel.text = iAMode.info;
        
        [self.view addSubview:detailsLabel];
        self.detailsLabel = detailsLabel;
    }
    
    //圆角
    self.restartBtn.layer.cornerRadius = 15;
    self.restartBtn.layer.masksToBounds = YES;
}

//点击结果按钮
-(void)touchResult
{
    if (self.resultView.backgroundColor == [UIColor colorWithRed:0 green:108/255.0 blue:181/255.0 alpha:1]) {
        return;
    }else{
        self.resultView.backgroundColor = [UIColor colorWithRed:0 green:108/255.0 blue:181/255.0 alpha:1];
        self.photoView.backgroundColor = [UIColor grayColor];
        //切换成结果
        self.pageScrollView.alpha = 0;
        self.pageControl.alpha = 0;
        self.bigView.alpha = 1;
        if (self.detailsLabel) {
            self.detailsLabel.alpha = 1;
        }
    }
}

//点击照片按钮
-(void)touchPhoto
{
    if (self.photoView.backgroundColor == [UIColor colorWithRed:0 green:108/255.0 blue:181/255.0 alpha:1]) {
        return;
    }else{
        self.photoView.backgroundColor = [UIColor colorWithRed:0 green:108/255.0 blue:181/255.0 alpha:1];
        self.resultView.backgroundColor = [UIColor grayColor];
        //切换成结果
        self.pageScrollView.alpha = 1;
        self.pageControl.alpha = 1;
        self.bigView.alpha = 0;
        if (self.detailsLabel) {
            self.detailsLabel.alpha = 0;
        }
    }
}


-(void)addResultTitle:(NSString*)title by:(BOOL)success
{
    
    UIResultItemLabel *itemLabel = [[UIResultItemLabel alloc] initWithLabel:title success:success];
    
    _resultTitleCount++;//增加起始距离
    
    
    
    itemLabel.frame = CGRectMake((self.bigView.frame.size.width - 240)/2, _resultTitleCount * 30, 240, 26);
    
    [self.bigView addSubview:itemLabel];
    
    
}

-(void)addPhotoToScrollbar:(UIImage*)image withLabel:(NSString*)title
{
    
    NSInteger page = self.pageControl.numberOfPages;
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(page * 240, 12, 240, 20);
    label.textColor = GOOD_UICOLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    imageView.frame = CGRectMake(page * 240, 32, 240, 308);
    
    
    [self.pageScrollView addSubview:label];
    [self.pageScrollView addSubview:imageView];
    
    self.pageControl.numberOfPages = ++page;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:194/255.0 green:210/255.0 blue:225/255.0 alpha:1];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:7/255.0 green:136/255.0 blue:202/255.0 alpha:1];

    
    [self.pageScrollView setContentSize:CGSizeMake(240 * page, 340)];
    
    self.pageScrollView.pagingEnabled = YES;//分页

}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSInteger page = scrollView.contentOffset.x / 240;
    if (page != self.pageControl.currentPage)
    {
        self.pageControl.currentPage = page;
    }
}

- (IBAction)back:(id)sender {
    
}

@end
