//
//  ViewController.m
//  Xcode 自带字体
//
//  Created by kkqb on 16/7/18.
//  Copyright © 2016年 kkqb. All rights reserved.
//

#import "ViewController.h"

#define K_MAIN_VIEW_SCROLL_HEIGHT 50.f
#define K_MAIN_VIEW_SCROLL_TEXT_TAG 300
#define K_MAIN_VIEW_TEME_INTERVAL 0.35         //计时器间隔时间(单位秒)
#define K_MAIN_VIEW_SCROLLER_SPACE 20          //每次移动的距离
#define K_MAIN_VIEW_SCROLLER_LABLE_WIDTH  ([UIScreen mainScreen].bounds.size.width)  //字体宽度
//#define K_MAIN_VIEW_SCROLLER_LABLE_MARGIN 0   //前后间隔距离

@interface ViewController ()
{
    UILabel *typeLabel;
    
    
    UILabel *label;
    
    NSArray *arrs;
    
    NSInteger index;
    
    UILabel *indexLabel;
    
    NSTimer           *timer;
    UIScrollView      *scrollViewText;
}
@property (nonatomic ,strong) NSArray *arrData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrs = [UIFont familyNames];
    
    NSLog(@"arrs:%@",arrs);
    
    index = 0;
    
    
    [self setUI];
    
    [self initView];
    
}

- (void) setUI{
    
    CGFloat Width = [UIScreen mainScreen].bounds.size.width;
    
    NSArray *titles = @[@"上一类",@"下一类"];
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(Width/2 - 40, 100 + 80*i, 80, 30);
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:titles[i] forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.tag = i + 10;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(Width/2 - 100, 140, 200, 30)];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.textColor = [UIColor lightGrayColor];
    typeLabel.font = [UIFont fontWithName:arrs[index] size:16];
    typeLabel.text = arrs[index];
    typeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:typeLabel];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, Width, 160)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"1234567890   \n 三大理由欧元任性抗跌";
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:arrs[index] size:30];
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, Width, 160)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor lightGrayColor];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"1234567890  \n 三大理由欧元任性抗跌";
    label1.numberOfLines = 0;
    label1.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:label1];
    
    indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 380, Width, 25)];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor lightGrayColor];
    indexLabel.backgroundColor = [UIColor clearColor];
    indexLabel.text = @"index : 0";
    indexLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:indexLabel];
    
}
#pragma mark - Custom method
//初始化数据
-(void) initView{
    
    if (!self.arrData) {
        self.arrData = @[
                         @{
                             @"newsId":@"21507070942261935",
                              @"newsImg":@"http://bg.fx678.com/HTMgr/upload/UpFiles/20150707/sy_2015070709395519.jpg",
                              @"newsTitle": @"三大理由欧元任性抗跌，欧元区峰会将为逆"
                                  },
                         @{
                             @"newsId":@"201507070929021220",
                              @"newsImg":@"http://bg.fx678.com/HTMgr/upload/UpFiles/20150707/sy_2015070709273545.jpg",
                              @"newsTitle" :@"欧盟峰会或现希腊转机，黄金打响1162保显"
                              },
                         @{
                             @"newsId":@"201507070656471857",
                              @"newsImg":@"http://bg.fx678.com/HTMgr/upload/UpFiles/20150707/2015070706533134.jpg",
                              @"newsTitle": @"希腊困局欧元不怕，油价服软暴跌8%是真事"
                              }
                         ];
    }
    
    //文字滚动
    [self initScrollText];
    
    //开启滚动
    [self startScroll];
}
//文字滚动初始化
-(void) initScrollText{
    
    //获取滚动条
    scrollViewText = (UIScrollView *)[self.view viewWithTag:K_MAIN_VIEW_SCROLL_TEXT_TAG];
    if(!scrollViewText){
        scrollViewText = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, K_MAIN_VIEW_SCROLL_HEIGHT)];
        scrollViewText.showsHorizontalScrollIndicator = NO;   //隐藏水平滚动条
        scrollViewText.showsVerticalScrollIndicator = NO;     //隐藏垂直滚动条
//        scrollViewText.scrollEnabled = NO;
        scrollViewText.tag = K_MAIN_VIEW_SCROLL_TEXT_TAG;
        [scrollViewText setBackgroundColor:[UIColor grayColor]];
        
        //清除子控件
        for (UIView *view in [scrollViewText subviews]) {
            [view removeFromSuperview];
        }
        
        //添加到当前视图
        [self.view addSubview:scrollViewText];
    }
    
    
    if (self.arrData) {
        
        CGFloat offsetX = 0 ,i = 0, h = 30;
        
        //设置滚动文字
        UILabel *labText = nil;
        for (NSDictionary *dicTemp in self.arrData) {
            labText = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                i * K_MAIN_VIEW_SCROLLER_LABLE_WIDTH,
                                                                (K_MAIN_VIEW_SCROLL_HEIGHT - h) / 2,
                                                                K_MAIN_VIEW_SCROLLER_LABLE_WIDTH,
                                                                h)];
            [labText setFont:[UIFont systemFontOfSize:16]];
            [labText setTextColor:[UIColor redColor]];
//            labText.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
            labText.textAlignment = NSTextAlignmentCenter;
            labText.text = dicTemp[@"newsTitle"];
            
            offsetX += labText.frame.size.width;
            
            //添加到滚动视图
            [scrollViewText addSubview:labText];
            
            i++;
        }
        
        //设置滚动区域大小
        [scrollViewText setContentSize:CGSizeMake(offsetX, 0)];
    }
}


//开始滚动
-(void) startScroll{
    
    if (!timer)
        timer = [NSTimer scheduledTimerWithTimeInterval:K_MAIN_VIEW_TEME_INTERVAL target:self selector:@selector(setScrollText) userInfo:nil repeats:YES];
    
    [timer fire];
}


//滚动处理
-(void) setScrollText{
    
    CGFloat startX = scrollViewText.contentSize.width - K_MAIN_VIEW_SCROLLER_LABLE_WIDTH - K_MAIN_VIEW_SCROLLER_SPACE;
    
    [UIView animateWithDuration:K_MAIN_VIEW_TEME_INTERVAL * 2 animations:^{
        CGRect rect;
        CGFloat offsetX = 0.0;
        
        for (UILabel *lab in scrollViewText.subviews) {
            
            rect = lab.frame;
            offsetX = rect.origin.x - K_MAIN_VIEW_SCROLLER_SPACE;
            
            [UIView setAnimationsEnabled:YES];
            
            if (offsetX < -K_MAIN_VIEW_SCROLLER_LABLE_WIDTH){
                lab.hidden = YES;
                offsetX = startX;
                [UIView setAnimationsEnabled:NO];
                
            }else if(lab.hidden){
                lab.hidden = NO;
            }
            
            lab.frame = CGRectMake(offsetX, rect.origin.y, rect.size.width, rect.size.height);
            
        }
        
    }];
    
}

- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == 10) {
        if (index == 0) {
            index = [arrs count] - 1;
        }else{
            index --;
        }
    }else{
        if (index == [arrs count] - 1) {
            index = 0;
        }else{
            index ++;
        }
    }
    typeLabel.font = [UIFont fontWithName:arrs[index] size:16];
    typeLabel.text = arrs[index];
    label.font = [UIFont fontWithName:arrs[index] size:30];
    
    indexLabel.text = [NSString stringWithFormat:@"index : %ld",index];
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }else{
        [self startScroll];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
