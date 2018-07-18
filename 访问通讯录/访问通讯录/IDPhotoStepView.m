//
//  IDPhotoStepView.m
//  JYVivoUI2
//
//  Created by jock li on 16/5/1.
//  Copyright © 2016年 timedge. All rights reserved.
//

#import "IDPhotoStepView.h"
#import "JYVivoUI2.h"
#import "idCardAdoptMode.h"
#import "OcrResultViewController.h"
#import "RecognitionController.h"


@interface IDPhotoStepView () <JYVivoUIStepDelegate>
{
    JYVivoUIStepNext _next;
}

@property(nonatomic,weak) UIButton *focusButton;
@property(nonatomic,weak) UIImageView *maskImageView;
@property(nonatomic,weak) UIImageView *previewImageView;//照片
@property(nonatomic,weak) UIButton *takePictureButton;
@property(nonatomic,weak) UIButton *nextButton;

@property(nonatomic,weak) UIButton *label;

@property(nonatomic,weak) UIButton *bottomLabel;
@property(nonatomic,weak) UIButton *bottomLabel2;

@property(nonatomic,weak) UIButton * textBtn;//提示不成功

@property(nonatomic,weak) NSTimer *timer;


@property(nonatomic,assign) bool bNext;

@end

@implementation IDPhotoStepView

-(void)initSelf
{
    _bNext = false;
    
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    UIButton* focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [focusButton addTarget:self action:@selector(maskAreaTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *maskImageVIew = [UIImageView new];
    maskImageVIew.image = [UIImage imageNamed:@"idcard_bg.png"];
    
    UIImageView *previewImageView = [UIImageView new];
    previewImageView.contentMode = UIViewContentModeScaleAspectFill;
    previewImageView.clipsToBounds = YES;
    previewImageView.hidden = YES;
    
    UIButton* takePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePictureButton setImage:[UIImage imageNamed:@"btn_photo_n.png"] forState:UIControlStateNormal];
    [takePictureButton setImage:[UIImage imageNamed:@"btn_photo_p.png"] forState:UIControlStateHighlighted];
    [takePictureButton setAdjustsImageWhenHighlighted:NO];
    [takePictureButton addTarget:self action:@selector(takePicutre:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    [nextButton setBackgroundColor:[UIColor colorWithRed:26/255.0 green:158/255.0 blue:215/255.0 alpha:1]];
    nextButton.userInteractionEnabled = NO;
    
    [nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:focusButton];
    [self addSubview:previewImageView];
    [self addSubview:maskImageVIew];
    [self addSubview:takePictureButton];
    [self addSubview:nextButton];
    
    self.focusButton = focusButton;
    self.maskImageView = maskImageVIew;
    self.previewImageView = previewImageView;
    self.takePictureButton = takePictureButton;
    self.nextButton = nextButton;
    
    //提示语
    UIButton *label = [[UIButton alloc]init];
    
    self.label = label;
    [self.label.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];//换行
    [self.label.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.label setTitle:@"请尽量将\n身份证与框对齐" forState:UIControlStateNormal];
    [self.label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.label];
    self.label.titleLabel.textAlignment = NSTextAlignmentCenter;//居中显示
    
    UIButton *bottomLabel = [[UIButton alloc]init];
    self.bottomLabel = bottomLabel;
    [self.bottomLabel.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.bottomLabel setTitle:@"请拍摄身份证" forState:UIControlStateNormal];
    [self.bottomLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.bottomLabel];
    
    UIButton *bottomLabel2 = [[UIButton alloc]init];
    self.bottomLabel2 = bottomLabel2;
    [self.bottomLabel2.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.bottomLabel2 setTitleColor:[UIColor colorWithRed:144/255.0 green:238/255.0 blue:144/255.0 alpha:YES] forState:UIControlStateNormal];
    [self.bottomLabel2 setTitle:@"正面照" forState:UIControlStateNormal];
    [self addSubview:self.bottomLabel2];
    
    
    
    UIButton *textBtn = [[UIButton alloc] init];
    self.textBtn = textBtn;
    [self.textBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.textBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.textBtn setTitle:@"身份证位置不正确" forState:UIControlStateNormal];
    self.textBtn.alpha = 0;
    [self addSubview:self.textBtn];
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoIsOk) name:@"photoIsOk" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocrExit) name:@"ocrExit" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocrBack) name:@"ocrBack" object:nil];
    
    
}

-(void)ocrExit
{
    if (_next)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartHjjc" object:self];
        _next();
    }
}

-(void)ocrBack
{

}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initSelf];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSelf];
    }
    return self;
}

-(void)layoutSubviews
{
    const CGSize TakePictureButtonSize = CGSizeMake(55, 55); // 拍照按钮尺寸
    const CGSize NextButtonSize = CGSizeMake(self.frame.size.width - 100 , 45); // 下一步按钮尺寸
    const CGFloat ButtonMarginBottom = 20; // 按钮底部空间
    CGSize size = self.frame.size;
    
    if (!self.isHidden)
    {
        // 将预览视频全屏
        [[[JYAVSessionHolder instance] videoView] setClipsToBounds:YES];
        
        [[[JYAVSessionHolder instance] videoView] setFrame:self.superview.frame];
    }

    CGFloat maskTop = VIDEO_VIEW_TOP - 616/4;
    CGFloat maskLeft = (size.width-480) / 2;
    
    CGSize windowSize  = [ UIScreen mainScreen ].bounds.size;//获取屏幕尺寸
    
    self.maskImageView.frame = CGRectMake(maskLeft, maskTop, 480, windowSize.height-10);//遮挡区的高度
    
//    self.previewImageView.frame =
    self.previewImageView.frame = CGRectMake(0, (self.frame.size.height-(self.frame.size.width)/480*640)/2, self.frame.size.width, (self.frame.size.width)/480*640);
    self.focusButton.frame = CGRectMake(-40, 0, windowSize.width+80, windowSize.height-80);


    self.nextButton.frame = CGRectMake((size.width - NextButtonSize.width)/2, size.height - NextButtonSize.height - ButtonMarginBottom, NextButtonSize.width, NextButtonSize.height);
    
    self.takePictureButton.frame = CGRectMake((size.width - TakePictureButtonSize.width) / 2, self.nextButton.frame.origin.y - TakePictureButtonSize.height - 20, TakePictureButtonSize.width, TakePictureButtonSize.height);
    
    self.nextButton.layer.cornerRadius = self.nextButton.frame.size.height/2;
    self.nextButton.layer.masksToBounds = YES;
    
    self.nextButton.alpha = 0.7;
    
    self.label.userInteractionEnabled = YES;
    self.label.frame = CGRectMake(self.frame.size.width/2-115, self.frame.size.height/2-90, 230, 100);
    
    self.label.transform = CGAffineTransformRotate(self.label.transform, M_PI_4);
    
    self.bottomLabel.userInteractionEnabled = YES;
    self.bottomLabel.frame = CGRectMake(-40, self.frame.size.height/2-82, 120, 30);
    self.bottomLabel.transform = CGAffineTransformRotate(self.bottomLabel.transform, M_PI_4);
    
    self.bottomLabel2.userInteractionEnabled = YES;
    self.bottomLabel2.frame = CGRectMake(-20, self.frame.size.height/2-13, 80, 30);
    self.bottomLabel2.transform = CGAffineTransformRotate(self.bottomLabel2.transform, M_PI_4);
    
    self.textBtn.userInteractionEnabled = YES;
    self.textBtn.frame = CGRectMake(self.frame.size.width-90, self.frame.size.height/2-70, 150, 30);
    self.textBtn.transform = CGAffineTransformRotate(self.textBtn.transform, M_PI_4);
    
    
    
}

#pragma mark - Actions
-(void)maskAreaTouch:(id)sender
{
    [[JYAVSessionHolder instance] autoFocus];
}


-(void)photoIsOk
{
    dispatch_async(dispatch_get_main_queue(), ^{
        idCardAdoptMode *mode = [[idCardAdoptMode alloc] init];
        
        self.previewImageView.contentMode = UIViewContentModeScaleToFill;
        
        self.previewImageView.image = [UIImage imageWithData:mode.idCardData];

        self.previewImageView.hidden = NO;
        
        NSString *tmpDir = NSTemporaryDirectory();
        NSString *tmpPath = [tmpDir stringByAppendingPathComponent:@"ICP_ID.JPG"];
        [mode.idCardData writeToFile:tmpPath atomically:NO];
        self.photoUrl = [[NSURL alloc] initFileURLWithPath:tmpPath];//保存到本地
        
        [self.nextButton setBackgroundColor:[UIColor colorWithRed:26/255.0 green:158/255.0 blue:215/255.0 alpha:1]];
        
        self.nextButton.userInteractionEnabled = YES;
        
        //跳转的时候,等2秒
        NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(takePictureOver) userInfo:nil repeats:NO];
        self.timer = timer;
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        
        [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        [self.label setTitle:@"可重拍" forState:UIControlStateNormal];
        
        self.nextButton.alpha = 1;
        
        self.nextButton.userInteractionEnabled = YES;
        
    });
}
//成功接受到自动识别的照片，准备跳转
-(void)takePictureOver
{
    if (_bNext == false) {
        _bNext = true;
    }
    else{
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.timer invalidate];
        
        
        OcrResultViewController * ocrResultVC = [[OcrResultViewController alloc] init];
        RecognitionController *RC = [self getCurrentViewController];
        [RC presentViewController:ocrResultVC animated:YES completion:nil];
        
        
        _bNext = false;
    });
}


-(RecognitionController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (RecognitionController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}


//拍照按钮
-(void)takePicutre:(id)sender
{
    idCardAdoptMode *mode = [[idCardAdoptMode alloc] init];
    mode.photoGraph = YES;
    if (!self.previewImageView.hidden)
    {
        // 重拍处理
        // 将预览视频全屏
//        [[[JYAVSessionHolder instance] videoView] setClipsToBounds:YES];
//        [[[JYAVSessionHolder instance] videoView] setFrame:self.superview.frame];
        
        mode.adopt = NO;

        [self.timer invalidate];

        [self.nextButton setBackgroundColor:[UIColor colorWithRed:26/255.0 green:158/255.0 blue:215/255.0 alpha:1]];
        self.nextButton.userInteractionEnabled = NO;
        
        [self.label setTitle:@"请尽量将\n身份证与框对齐" forState:UIControlStateNormal];
        
        self.nextButton.alpha = 0.7;
        
        
        self.previewImageView.hidden = YES;
        self.previewImageView.image = nil;
        self.photoUrl = nil;
        mode.photoGraph = NO;
        
        self.textBtn.alpha = 0;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"timerStart" object:self];
        
        return;
    }
    [[JYAVSessionHolder instance] takePicture:^(NSURL *savedUrl)
    {   //获取照片
        if (savedUrl)
        {

            self.previewImageView.image = [UIImage imageWithContentsOfFile:savedUrl.path];
            
//            self.previewImageView.frame = ;
//              self.previewImageView.frame = CGRectMake(0, (self.frame.size.height-(self.frame.size.width)/480*640)/2, self.frame.size.width, (self.frame.size.width)/480*640);
            
            self.previewImageView.hidden = NO;
            [self.label setTitle:@"可重拍" forState:UIControlStateNormal];
            
            self.nextButton.alpha = 1;
            
            self.nextButton.userInteractionEnabled = YES;
            
            mode.photoGraph = NO;

            if (mode.adopt == NO)
            {
                mode.adopt = YES;

                [UIView animateWithDuration:0.7 animations:^{
                    self.textBtn.alpha = 1;
                }];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"timerStop" object:self];
            
            
        } else
        {

            [UIView animateWithDuration:0.7 animations:^{
                self.textBtn.alpha = 1;
            } completion:^(BOOL finished)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.textBtn.alpha = 0;
                }];
            }];
            
            self.previewImageView.hidden = YES;
            self.previewImageView.image = nil;
            
            self.nextButton.alpha = 0.7;
            
            self.nextButton.userInteractionEnabled = NO;
            
            [self.label setTitle:@"请尽量将\n身份证与框对齐" forState:UIControlStateNormal];
        }
        self.photoUrl = savedUrl;
        mode.photoGraph = NO;
    }];
    
}

-(void)next:(id)sender
{
    if (_bNext == false) {
        _bNext = true;
    }
    else{
        return;
    }
        
    if (_photoUrl == nil)
    {
        [[[UIAlertView alloc] initWithTitle:@"错误" message:@"必须提供证件照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        return;
    }
    if (_next)
    {
        [self.timer invalidate];

        OcrResultViewController * ocrResultVC = [[OcrResultViewController alloc] init];
        RecognitionController *RC = [self getCurrentViewController];
        [RC presentViewController:ocrResultVC animated:YES completion:nil];
        
    }
    _bNext = false;
}


#pragma mark - JYVivoUIStepDelegate

-(void)stepLoad:(JYVivoUIStepNext)next
{
    _next = next;
}

-(NSString*)stepEnter
{
    
    [[JYAVSessionHolder instance] setDevicePosition:AVCaptureDevicePositionBack];//切换摄像头方向
    
    return @"证件扫描";
}

@end
