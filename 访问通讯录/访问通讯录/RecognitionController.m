//
//  RecognitionController.m
//  JYVivoUI2
//
//  Created by jock li on 16/4/27.
//  Copyright © 2016年 timedge. All rights reserved.
//

#import "RecognitionController.h"
#import "JYVivoUI2.h"
#import "UIStepView.h"
#import "IDPhotoStepView.h"
#import "idCardAdoptMode.h"
#import "ResultController.h"


@interface RecognitionController () <JYStepViewDelegate>

@property (strong, nonatomic) JYAVSessionHolder *sessionHolder;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIStepView *stepView;
@property (strong, nonatomic) UIStepView *stepNumberView;

@property (strong, nonatomic) UIButton *reButton;

@property (strong, nonatomic) IDPhotoStepView *idPhotoStepView;

@property (strong, nonatomic) JYVivoVideoView *videoView;

@property (strong, nonatomic) UIImageView *numberImgView;

//三个标签
@property (strong,nonatomic) UILabel *oneLabel;
@property (strong,nonatomic) UILabel *twoLabel;
@property (strong,nonatomic) UILabel *threeLabel;


@end



@implementation RecognitionController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"相机权限受限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.delegate = self;
        // 2.显示在屏幕上
        [alert show];
        
    }
    
    _sessionHolder = [JYAVSessionHolder instance];
    
    ////
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,20)];
    topView.backgroundColor = [UIColor colorWithRed:17/255.0 green:115/255.0 blue:191/255.0 alpha:1];
    //[self.view addSubview:topView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 60)];
    titleLabel.textAlignment = NSTextAlignmentCenter;//居中显示
    titleLabel.text = @"证件扫描";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:titleLabel];
    [titleLabel setTextColor:[UIColor colorWithRed:26/255.0 green:158/255.0 blue:215/255.0 alpha:1]];
    self.titleLabel = titleLabel;
    
    //返回键
    UIButton *reButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 35, 30, 30)];
    [self.view addSubview:reButton];
    self.reButton = reButton;
    [reButton setImage:[UIImage imageNamed:@"BackWhite"] forState:UIControlStateNormal];
    [reButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchDown];
    
    //播放view
    JYVivoVideoView *videoView = [_sessionHolder videoView];
    videoView.frame = CGRectMake(30, self.view.frame.size.height - (self.view.frame.size.width/3) - ((self.view.frame.size.width-60)/60*77),self.view.frame.size.width-60 , (self.view.frame.size.width-60)/60*77);
    [self.view addSubview:videoView];
    self.videoView = videoView;
    
    //显示环境检测和活体检测的view
    UIStepView* stepView = [[UIStepView alloc] init];
    stepView.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80);
    [self.view addSubview:stepView];
    self.stepView = stepView;
    
    ////
    
    // 初始化空步骤以进行进入处理
    self.stepView.step = -1;
    
    //设置为证件照
    idCardAdoptMode *mode =[[idCardAdoptMode alloc] init];
    mode.severalController = 0;
    
    //步骤标签
    UIImageView *numberImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_number_2"]];
    numberImgView.frame = CGRectMake(10, 100, self.view.frame.size.width - 20,(self.view.frame.size.width - 20)/15);
    
    self.numberImgView = numberImgView;
    [self.view addSubview:numberImgView];
    
    //三个标签
    //字体大小
    int textFont = 13;
    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, numberImgView.frame.origin.y + numberImgView.frame.size.height, (self.view.frame.size.width-20)/3, 20)];
    oneLabel.textAlignment = NSTextAlignmentCenter;//居中显示
    oneLabel.textColor = [UIColor blackColor];
    oneLabel.font = [UIFont systemFontOfSize:textFont];
    oneLabel.text = @"证件扫描";
    self.oneLabel = oneLabel;
    [self.view addSubview:oneLabel];
    
    UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+(self.view.frame.size.width-20)/3, numberImgView.frame.origin.y + numberImgView.frame.size.height, (self.view.frame.size.width-20)/3, 20)];
    twoLabel.textAlignment = NSTextAlignmentCenter;//居中显示
    twoLabel.textColor = [UIColor blackColor];
    twoLabel.font = [UIFont systemFontOfSize:textFont];
    twoLabel.text = @"环境检测中";
    self.twoLabel = twoLabel;
    [self.view addSubview:twoLabel];
    
    UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+(self.view.frame.size.width-20)/3+(self.view.frame.size.width-20)/3, numberImgView.frame.origin.y + numberImgView.frame.size.height, (self.view.frame.size.width-20)/3, 20)];
    threeLabel.textAlignment = NSTextAlignmentCenter;//居中显示
    threeLabel.textColor = [UIColor blackColor];
    threeLabel.font = [UIFont systemFontOfSize:textFont];
    threeLabel.text = @"活体检测";
    self.threeLabel =threeLabel;
    [self.view addSubview:threeLabel];
    
    
    // 步骤初始化，可自定义步骤
    // 第一步：身份证拍照
//    IDPhotoStepView *idPhotoStepView = [IDPhotoStepView new];
//    [_stepView addSubview:idPhotoStepView];
//    self.idPhotoStepView = idPhotoStepView;
    
    // 第二步：环境检测
    [_stepView addSubview:[JYEnvStepView new]];
    
    
    // 第三步：活体检测
    [_stepView addSubview:[JYIdentifyStepView new]];
    
    self.reButton.userInteractionEnabled = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingToJYIdentifyStepView) name:@"loadingToJYIdentifyStepView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startHtjc) name:@"StartHtjc" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startHjjc) name:@"StartHjjc" object:nil];
    
    [self startHjjc];
    
    self.continuingNetworking = [[ContinuingNetworking alloc] init];
    
    [self.continuingNetworking startNetworking];

    [_sessionHolder start];
}

-(void)startHjjc
{
    
    [self.numberImgView setImage: [UIImage imageNamed:@"icon_number_2"]];
    
    self.videoView.frame = CGRectMake(30, self.view.frame.size.height - (self.view.frame.size.width/3) - ((self.view.frame.size.width-60)/60*77),self.view.frame.size.width-60 , (self.view.frame.size.width-60)/60*77);
    
    self.titleLabel.text = @"环境检测";
    
    //三个标签
    self.oneLabel.text = @"证件扫描";
    self.twoLabel.text = @"环境检测中";
    self.threeLabel.text = @"活体检测";
    
}


-(void)startHtjc
{

    [self.numberImgView setImage:[UIImage imageNamed:@"icon_number_3"]];
    
    self.videoView.frame = CGRectMake(30, self.view.frame.size.height - (self.view.frame.size.width/3) - ((self.view.frame.size.width-60)/60*77),self.view.frame.size.width-60 , (self.view.frame.size.width-60)/60*77);
    self.titleLabel.text = @"活体检测";
    //三个标签
    self.oneLabel.text = @"证件扫描";
    self.twoLabel.text = @"环境检测";
    self.threeLabel.text = @"活体检测中";

}

- (void)loadingToJYIdentifyStepView
{
    if (_stepView.step == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //正在进入活体时候，让返回键无法点击
            self.reButton.userInteractionEnabled = NO;
        });
        //延迟1秒,无法点击返回按钮
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.reButton.userInteractionEnabled = YES;
            
            idCardAdoptMode *mode = [[idCardAdoptMode alloc] init];
            mode.severalController = -1;
            [_sessionHolder stop];
            
            [self onStepComplete];//结束
            
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //正在进入活体时候，让返回键无法点击
            self.reButton.userInteractionEnabled = NO;
        
        });
        //延迟2秒,无法点击返回按钮
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            self.reButton.userInteractionEnabled = YES;
        
        });
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{

    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBack
{
    idCardAdoptMode *mode = [[idCardAdoptMode alloc] init];

    if(_stepView.step == 0) {
        mode.adopt = NO;
        
        [self.continuingNetworking stopNetworking];
        
        mode.severalController = -1;//设置为不在任何控制器
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];//关闭通知
        
        idCardAdoptMode *mode = [[idCardAdoptMode alloc] init];
        mode.severalController = -1;
        
        self.stepView.step = -1;
        
    }
    else if(_stepView.step == 1)
    {
        [self.numberImgView setImage:[UIImage imageNamed:@"icon_number_2"]];
        
        mode.severalController = 0;//设置为正在环境检测
        
        self.videoView.frame =  CGRectMake(30, self.view.frame.size.height - (self.view.frame.size.width/3) - ((self.view.frame.size.width-60)/60*77),self.view.frame.size.width-60 , (self.view.frame.size.width-60)/60*77);
        
        
        self.titleLabel.text = @"环境检测";
        
        //三个标签
        self.oneLabel.text = @"证件扫描";
        self.twoLabel.text = @"环境检测中";
        self.threeLabel.text = @"活体检测";
        
        _stepView.step = 0;
    }
}

#pragma mark - JYStepViewDelegate

- (void)onStepComplete
{
    [_sessionHolder stop2];
    // 步骤已结束，导航到结果显示界面
    self.stepView.step = -1;
    [self.continuingNetworking stopNetworking];
    
    
    ///////
    [[NSNotificationCenter defaultCenter] removeObserver:self];//关闭通知
    
    idCardAdoptMode *mode = [[idCardAdoptMode alloc] init];
    
    mode.adopt = NO;
    
    mode.severalController = -1;
    

    
    
    self.stepView.step = -1;
    ////////
    
    
    //这里，结束活体检测，跳转到下一个界面
    ResultController * resultVC = [[ResultController alloc] init];
    //跳转
    [self presentViewController:resultVC animated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"result"])
    {
        [segue.destinationViewController setPersonInfo:self.personInfo];
    }
    [super prepareForSegue:segue sender:sender];
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [_sessionHolder stop2];
    [super viewWillDisappear:animated];
    
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];//关闭通知
    
//    idCardAdoptMode *mode = [[idCardAdoptMode alloc] init];
//    mode.severalController = -1;
    
//    self.stepView.step = -1;
}

@end
