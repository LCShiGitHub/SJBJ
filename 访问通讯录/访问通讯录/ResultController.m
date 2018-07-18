//
//  ResultController.m
//  JYVivoUI2
//
//  Created by jock li on 16/5/2.
//  Copyright © 2016年 timedge. All rights reserved.
//

#import "ResultController.h"
#import "JYVivoUI2.h"
#import "HttpService.h"
#import "idCardAdoptMode.h"
#import "ResultDetialController.h"
#import "o_ResponseMode.h"


// 授权使用的APP项目编号字符串。由上海骏聿分配。
const NSString* projectNum ;

@interface ResultController ()<UIAlertViewDelegate>
@property (weak, nonatomic) UILabel *resultLabel;
@property (weak, nonatomic) UIButton *buttonRestart;//重新开始按钮
@property (weak, nonatomic) UIButton *buttonDetial;//查看详情按钮

@property (weak, nonatomic) UITapGestureRecognizer *recognizer;

@property(nonatomic,strong) UILabel *downLabel;

@property(nonatomic,strong) NSTimer *timer;

@property(nonatomic,strong) UIImageView *spot1;
@property(nonatomic,strong) UIImageView *spot2;
@property(nonatomic,strong) UIImageView *spot3;
@end

@implementation ResultController


bool bSuspend = NO;
int tmp;    //用于记录在载入时，是哪个点为空心（载入中字样后）

-(UIImageView *)spot1
{
    if (_spot1 == nil) {
        UIImageView *tmp = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+20, self.view.frame.size.height/2-5, 9, 9)];
        
        _spot1 = tmp;
        [self.view addSubview:_spot1];
    }
    return _spot1;
}


-(UIImageView *)spot2
{
    if (_spot2 == nil) {
        UIImageView *tmp = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+31, self.view.frame.size.height/2-5, 9, 9)];
        _spot2 = tmp;
        [self.view addSubview:_spot2];
    }
    return _spot2;
}

-(UIImageView *)spot3
{
    if (_spot3 == nil) {
        UIImageView *tmp = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+42, self.view.frame.size.height/2-5, 9, 9)];
        _spot3 = tmp;
        [self.view addSubview:_spot3];
    }
    return _spot3;
}


-(void)networking
{
    
    if (tmp == 0) {
        self.spot1.image = [UIImage imageNamed:@"office_waitingbar_indicator_sel"];
        self.spot2.image = [UIImage imageNamed:@"office_waitingbar_indicator"];
        self.spot3.image = [UIImage imageNamed:@"office_waitingbar_indicator"];
        tmp++;
    }
    else if (tmp  == 1)
    {
        self.spot2.image = [UIImage imageNamed:@"office_waitingbar_indicator_sel"];
        self.spot1.image = [UIImage imageNamed:@"office_waitingbar_indicator"];
        self.spot3.image = [UIImage imageNamed:@"office_waitingbar_indicator"];
        tmp++;
    }
    else if(tmp  == 2)
    {
        self.spot3.image = [UIImage imageNamed:@"office_waitingbar_indicator_sel"];
        self.spot1.image = [UIImage imageNamed:@"office_waitingbar_indicator"];
        self.spot2.image = [UIImage imageNamed:@"office_waitingbar_indicator"];
        tmp = 0;
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    ////////////
    //背景图
    UIImageView *backgroundImgV =[[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImgV.image = [UIImage imageNamed:@"result_bg"];
    backgroundImgV.userInteractionEnabled = YES;
    [self.view addSubview:backgroundImgV];
    
    //中心图
    UIImageView *centerImgV = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-166)/2,(self.view.frame.size.height - 166)/2, 166, 166)];
    centerImgV.userInteractionEnabled = YES;
    [backgroundImgV addSubview:centerImgV];
    
    //提示语
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-140)/2, (self.view.frame.size.height-21)/2, 140, 21)];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    self.resultLabel = resultLabel;
    [backgroundImgV addSubview:resultLabel];
    
    //重新开始按钮
    UIButton *buttonRestart = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100)/2, self.view.frame.size.height - 100, 100, 30)];
    self.buttonRestart = buttonRestart;
    [buttonRestart setTitle:@"重新开始" forState:UIControlStateNormal];
    [buttonRestart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonRestart setBackgroundColor:[UIColor colorWithRed:254/255.0 green:195/255.0 blue:97/255.0 alpha:1]];
    [buttonRestart addTarget:self action:@selector(reStart) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImgV addSubview:buttonRestart];
    
    //查看详情按钮
    UIButton *buttonDetial = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100)/2, buttonRestart.frame.origin.y+buttonRestart.frame.size.height + 30, 100, 30)];
    self.buttonDetial = buttonDetial;
    [buttonDetial setTitle:@"查看详情" forState:UIControlStateNormal];
    [buttonDetial setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonDetial setBackgroundColor:[UIColor colorWithRed:19/255.0 green:124/255.0 blue:104/255.0 alpha:1]];
    [buttonDetial addTarget:self action:@selector(Detial) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImgV addSubview:buttonDetial];
    
    ////////////
    
    
    tmp = 0;

    self.buttonRestart.layer.cornerRadius = 15;
    self.buttonRestart.layer.masksToBounds = YES;

    self.buttonDetial.layer.cornerRadius = 15;
    self.buttonDetial.layer.masksToBounds = YES;
    
    projectNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"projectID"];
    
    //允许交互
    self.resultLabel.userInteractionEnabled = YES;
    
    //添加点击
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    self.recognizer = recognizer;
    
    
    JYVivoResult* result = [[JYAVSessionHolder instance] result];
    
    if (result.success) {
        self.buttonDetial.hidden = YES;
        self.buttonRestart.hidden = YES;
        self.resultLabel.text = @"联网中\t\t";
        //定时器
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(networking) userInfo:nil repeats:YES];
        self.timer = timer;
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        
        [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        [self.timer fire];
        
        
        [self.resultLabel addGestureRecognizer:self.recognizer];
        [self.recognizer addTarget:self action:@selector(suspend)];
        
        
        self.personInfo.jpgBuffer = result.jpgData;
        self.personInfo.idJpgBuffer = result.idJpgData;
        self.personInfo.packagedData = result.packagedData;
        self.personInfo.photos = result.photos;
        self.personInfo.projectNum = [projectNum copy];
        
        NSURL *postUrl = [[NSURL URLWithString:[[JYAVSessionHolder instance] serviceUrl]] URLByAppendingPathComponent:@"servlet/ReceiveBestPhotoServlet"];
        
        idCardAdoptMode *mode = [[idCardAdoptMode alloc] init];
        
        [[HttpService service] post:postUrl body:[self postBody] success:^(NSInteger statusCode, NSData *body)
         {
             if (bSuspend == NO)//没有取消联网
             {
                 NSError *error = nil;
                 
                 NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:body options:kNilOptions error:&error];
                 //不允许交互
                 self.resultLabel.userInteractionEnabled = NO;
                 [self.timer invalidate];
                 [self.spot1 removeFromSuperview];
                 [self.spot2 removeFromSuperview];
                 [self.spot3 removeFromSuperview];
                 if (error || dict == nil)
                 {
                     mode.info = @"服务器错误";
                     [self showResult:NO message:@"比对异常"]; //详情：服务器错误
                     //self.buttonDetial.hidden = YES;
                     
                     // 比对结果，0成功，-1失败(默认)，1无法判定修改为0成功，-1无法判定，<-1失败
                     mode.compareSuccess = -1;
                     
                     // 结果信息
                     mode.resultInfo = nil;
                     // 服务器三通测试结果信息
                     mode.resultInfos = nil;
                     
                     return;
                 }
                 
                 mode.info = [dict objectForKey:@"info"];
                 
                 [self handleResult:dict];
                 
                 if (mode.compareSuccess == 0)
                 {
                     
                     [self showResult:mode.compareSuccess == 0 message:@"已通过"];
                 }
                 else if(mode.compareSuccess == -2||
                         mode.compareSuccess == -12||
                         mode.compareSuccess == -13||
                         mode.compareSuccess == -14||
                         mode.compareSuccess == -26||
                         mode.compareSuccess == -27)
                 {
                     [self showResult:mode.compareSuccess == 0 message:@"未通过"];
                 }
                 else if(mode.compareSuccess == -1)
                 {
                     [self showResult:mode.compareSuccess == 0 message:@"无法判定"];
                 }else
                 {
                     [self showResult:mode.compareSuccess == 0 message:@"比对异常"];
                 }
                 
             }else
             {
                 [self.timer invalidate];
                 [self.spot1 removeFromSuperview];
                 [self.spot2 removeFromSuperview];
                 [self.spot3 removeFromSuperview];
                 self.resultLabel.userInteractionEnabled = NO;
                 return;
             }
         } fail:^(NSError *error)
         {
             [self.timer invalidate];
             [self.spot1 removeFromSuperview];
             [self.spot2 removeFromSuperview];
             [self.spot3 removeFromSuperview];
             //不允许交互
             self.resultLabel.userInteractionEnabled = NO;
             if (bSuspend == NO)
             {
                 mode.info = @"连接超时，请稍候再试";
                 // 比对结果，0成功，-1失败(默认)，1无法判定修改为0成功，-1无法判定，<-1失败
                 mode.compareSuccess = -1;
                 
                 // 结果信息
                 mode.resultInfo = nil;
                 // 服务器三通测试结果信息
                 mode.resultInfos = nil;
                 
                 [self showResult:NO message:@"比对异常"]; //详情：连接超时，请稍后再试
                 
                 //self.buttonDetial.hidden = YES;
             }
         }];
        
    } else
    {
        [self.timer invalidate];
        [self.spot1 removeFromSuperview];
        [self.spot2 removeFromSuperview];
        [self.spot3 removeFromSuperview];
        
        //不允许交互
        self.resultLabel.userInteractionEnabled = NO;
        
        idCardAdoptMode *mode = [[idCardAdoptMode alloc] init];
        
        mode.info = @"活体检测失败";
        
        // 比对结果，0成功，-1失败(默认)，1无法判定修改为0成功，-1无法判定，<-1失败
        mode.compareSuccess = -1;
        
        // 结果信息
        mode.resultInfo = nil;
        
        // 服务器三通测试结果信息
        mode.resultInfos = nil;
        
        self.resultLabel.text = @"活体检测失败";  //详情：本地检测失败
        self.resultLabel.textColor = FAIL_UICOLOR;
        self.buttonDetial.hidden = YES;
    }
}

-(NSData*)postBody {
    NSMutableData *data = [[NSMutableData alloc] init];
    idCardAdoptMode *mode =[[idCardAdoptMode alloc] init];
    
    [data appendData:[[NSString stringWithFormat:@"strProjectNum=%@&", [[NSUserDefaults standardUserDefaults] objectForKey:@"projectID"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [data appendData:[[NSString stringWithFormat:@"strTaskGuid=%@&", mode.taskGuid] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [data appendData:[[NSString stringWithFormat:@"strPersonName=%@&", mode.name] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"strPersonId=%@&", mode.idCardNumber] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [data appendData:[@"bAliveCheck=true&" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [data appendData:[[@"strPhotoBase64=" stringByAppendingString:[mode.packagedData base64Encoding]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
//    [UIImage imageWithCGImage:mode.idCardImage.CGImage scale:1 orientation:UIImageOrientationUp];
    
    NSData *idcardData;
    if (mode.idCardImage) {
        idcardData = UIImageJPEGRepresentation(mode.idCardImage, 0.6);
    }
    
    if (idcardData)
    {
        [data appendData:[[@"&strIDPhotoBase64=" stringByAppendingString:[idcardData base64Encoding]] dataUsingEncoding:NSUTF8StringEncoding]];
    } else
    {
        [data appendData:[@"&strIDPhotoBase64=" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return data;
}


-(BOOL)handleResult:(NSDictionary*)json
{
    
    idCardAdoptMode *iAMode = [[idCardAdoptMode alloc] init];
    
    iAMode.compareSuccess = -1;
    
    if (json)
    {
        id netResult = [json objectForKey:@"result"];
        if (netResult)
        {
            iAMode.compareSuccess = [netResult intValue];
            NSMutableArray* infos = [NSMutableArray new];
            NSDictionary* o_response = [json objectForKey:@"o_response"];
            if (o_response)
            {
                for (int i=1; i<=3; i++)
                {
                    NSString *key = [NSString stringWithFormat:@"response_l%d", i];
                    NSDictionary *item =[o_response objectForKey:key];
                    o_ResponseMode *mode = [[o_ResponseMode alloc] init];
                    if (item)
                    {
                        mode.o_response = item;
                        mode.o_responseNumber = i;
                    }
                    if (mode.o_response)
                    {
                        [infos addObject:mode];
                    }
                }
            }
            iAMode.resultInfos = infos;
        }
    } else
    {
        iAMode.resultInfo = @"服务器错误";
    }
    
    return iAMode.compareSuccess == 0;
}

- (void)suspend
{

//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@" 取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    
//    [sheet showInView:self.view];//下方升起提示窗（二选一）
    
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否中断联网检查" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.delegate = self;
//    [alert show];                   //弹出提示窗（二选一）
}

//用第二种弹窗时
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        idCardAdoptMode *mode = [[idCardAdoptMode alloc] init];
        bSuspend = YES;
        [self.timer invalidate];
        [self.spot1 removeFromSuperview];
        [self.spot2 removeFromSuperview];
        [self.spot3 removeFromSuperview];
        self.buttonDetial.hidden = NO;
        self.buttonRestart.hidden = NO;
        self.resultLabel.text = @"已取消联网";
        mode.info = @"已取消";
        // 比对结果，0成功，-1失败(默认)，1无法判定修改为0成功，-1无法判定，<-1失败
        mode.compareSuccess = -1;
        
        // 结果信息
        mode.resultInfo = nil;
        // 服务器三通测试结果信息
        mode.resultInfos = nil;
    }
}

////用第一种弹窗时
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        //确定
//        //暂停
//        bSuspend = YES;
//        self.buttonDetial.hidden = NO;
//        self.buttonRestart.hidden = NO;
//        self.resultLabel.text = @"已取消联网";
//    }
//}

- (void)showResult:(BOOL)success message:(NSString*)text
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.resultLabel setTextColor:success ? GOOD_UICOLOR : FAIL_UICOLOR];
    [self.resultLabel setText:text];
    
    self.buttonRestart.hidden = NO;
    self.buttonDetial.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//查看详情按钮方法
- (void)Detial
{
    
    NSLog(@"进入查看详情");
    ResultDetialController *resultDetialVC =[[ResultDetialController alloc] init];
    
    //跳转
    [self presentViewController:resultDetialVC animated:YES completion:nil];
}


//重新开始按钮方法
- (void)reStart
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc
{
    bSuspend = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detial"]) {
        [segue.destinationViewController setPersonInfo:self.personInfo];
    }
    [super prepareForSegue:segue sender:sender];
}

@end
