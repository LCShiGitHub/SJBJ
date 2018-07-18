//
//  OcrResultViewController.m
//  JYVivoUI2
//
//  Created by junyufr on 2016/11/8.
//  Copyright © 2016年 timedge. All rights reserved.
//

#import "OcrResultViewController.h"
#import "JYAVSessionHolder.h"
#import "idCardAdoptMode.h"
#import "HttpService.h"


@interface OcrResultViewController ()   <UITextFieldDelegate>


@property(nonatomic,weak) UIButton *nextBtn;
@property(nonatomic,weak) UIButton *returnBtn;
@property(nonatomic,weak) UITextField *nameTextField;
@property(nonatomic,weak) UITextField *idCardNumberTextField;
@property(nonatomic,weak) UILabel *nameLabel;
@property(nonatomic,weak) UILabel *idCardNumberLabel;


@property (weak ,nonatomic) UIImageView * tmpImageview;
@property (weak ,nonatomic) UIActivityIndicatorView *testActivityIndicator; //正在载入旋转控件


//显示其他信息的label
@property(nonatomic,weak) UILabel *sexLabel;//性别
@property(nonatomic,weak) UILabel *forkLabel;//民族
@property(nonatomic,weak) UILabel *birthdayLabel;//生日
@property(nonatomic,weak) UILabel *addressLabel;//地址


@end

@implementation OcrResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设定背景颜色
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //顶部图片
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    topV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topV];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 60)];
    titleLabel.textAlignment = NSTextAlignmentCenter;//居中显示
    titleLabel.text = @"信息核对";
    titleLabel.textColor = [UIColor colorWithRed:32/255.0 green:163/255.0 blue:218/255.0 alpha:1];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:titleLabel];
    
    //logo图片
    UIImageView *logoImgV = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 125)/2, 65, 125, 125)];
    logoImgV.image = [UIImage imageNamed:@"login_logo"];
//    [self.view addSubview:logoImgV];
    
    //请输入登录信息字样
    UILabel *titleLable = [[UILabel alloc ] initWithFrame:CGRectMake((self.view.frame.size.width-210)/2, 150 , 210, 20)];
    titleLable.text = @"请仔细核对信息，如果有误请点击";
    titleLable.textAlignment = NSTextAlignmentCenter;//居中显示
    titleLable.font = [UIFont systemFontOfSize:13];
    [titleLable setTextColor:[UIColor blackColor]];
    [self.view addSubview:titleLable];
    
    //人证一致字样
    UILabel *title2Lable =[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 120)/2, titleLable.frame.origin.y - 8 - 40, 120, 40)];
    title2Lable.text = @"人证一致";
    title2Lable.textAlignment = NSTextAlignmentCenter;//居中显示
    title2Lable.font = [UIFont systemFontOfSize:26];
    title2Lable.textColor =[UIColor whiteColor];
//    [self.view addSubview:title2Lable];
    
    //左边的白线
    UIView *leftLineView = [[UIView alloc]initWithFrame:CGRectMake(20, titleLable.frame.origin.y +(titleLable.frame.size.height/2),titleLable.frame.origin.x - 20, 2)];
    leftLineView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftLineView];
    
    //右边的白线
    UIView *rightLineView = [[UIView alloc]initWithFrame:CGRectMake(titleLable.frame.origin.x + titleLable.frame.size.width  ,titleLable.frame.origin.y +(titleLable.frame.size.height/2) ,self.view.frame.size.width-40 - titleLable.frame.size.width -(titleLable.frame.origin.x - 20), 2)];
    rightLineView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightLineView];
    
    //下一步按钮
    UIButton *nextBtn = [[UIButton alloc] init];
    self.nextBtn = nextBtn;
    [nextBtn setBackgroundColor:[UIColor colorWithRed:78/255.0 green:187/255.0 blue:195/255.0 alpha:1]];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:nextBtn];
    
    //返回按钮
    UIButton *returnBtn = [[UIButton alloc] init];
    self.returnBtn = returnBtn;
    [returnBtn setImage:[UIImage imageNamed:@"BackWhite"] forState:UIControlStateNormal];
//    [returnBtn setTitle:@"返回" forState:UIControlStateNormal];
    [returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:returnBtn];
    
    
    UITextField *nameTextField = [[UITextField alloc] init];
    self.nameTextField = nameTextField;
    nameTextField.placeholder = @"请输入姓名";
    nameTextField.returnKeyType = UIReturnKeyNext;//return键为下一步
    nameTextField.font = [UIFont systemFontOfSize:13];
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;//显示边框样式
    nameTextField.delegate=self;//代理
    [self.view addSubview:nameTextField];
    
    UITextField *idCardNumberTextField = [[UITextField alloc] init];
    self.idCardNumberTextField = idCardNumberTextField;
    idCardNumberTextField.placeholder = @"请输入证件号";
    idCardNumberTextField.font = [UIFont systemFontOfSize:13];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:idCardNumberTextField];
    idCardNumberTextField.returnKeyType = UIReturnKeyGo;//return键为GO
    idCardNumberTextField.borderStyle = UITextBorderStyleRoundedRect;//显示边框样式
    idCardNumberTextField.delegate=self;//代理
    [self.view addSubview:idCardNumberTextField];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"姓名";
    self.nameLabel = nameLabel;
    [self.view addSubview:nameLabel];
    
    UILabel *idCardNumberLabel = [[UILabel alloc] init];
    idCardNumberLabel.text = @"证件号";
    self.idCardNumberLabel = idCardNumberLabel;
    [self.view addSubview:idCardNumberLabel];
    
    
    //设定frame
    self.returnBtn.frame = CGRectMake(10, 35, 30, 30);
    
    self.nameLabel.frame = CGRectMake(self.view.frame.size.width/4 - 30,titleLable.frame.origin.y+(self.view.frame.size.height - titleLable.frame.origin.y)/4 - 25 , 60, 30);
    self.nameTextField.frame = CGRectMake(self.view.frame.size.width/4 + 30,titleLable.frame.origin.y+(self.view.frame.size.height - titleLable.frame.origin.y)/4 - 25 , self.view.frame.size.width/2, 30);
    
    self.idCardNumberLabel.frame = CGRectMake(self.view.frame.size.width/4 - 30, titleLable.frame.origin.y+(self.view.frame.size.height - titleLable.frame.origin.y)/4 + 25, 60, 30);
    self.idCardNumberTextField.frame = CGRectMake(self.view.frame.size.width/4 + 30, titleLable.frame.origin.y+(self.view.frame.size.height - titleLable.frame.origin.y)/4 + 25, self.view.frame.size.width/2, 30);
    
    self.nextBtn.frame = CGRectMake(50, self.view.frame.size.height - 80, self.view.frame.size.width - 100, 40);
    
    
    self.nextBtn.layer.cornerRadius = 20;
    self.nextBtn.layer.masksToBounds = YES;
    
    UIButton *reStartBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.idCardNumberTextField.frame.origin.x + self.idCardNumberTextField.frame.size.width - 100, self.idCardNumberTextField.frame.origin.y + self.idCardNumberTextField.frame.size.height, 100, 20)];
    reStartBtn.backgroundColor = self.view.backgroundColor;
    reStartBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [reStartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reStartBtn setTitle:@"重新拍摄" forState:UIControlStateNormal];
    [reStartBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:reStartBtn];
    
    
    //显示其他信息
    //性别
    UILabel *sexL = [[UILabel alloc]initWithFrame:CGRectMake(self.idCardNumberLabel.frame.origin.x, self.idCardNumberLabel.frame.origin.y + self.idCardNumberLabel.frame.size.height + 35 , 50, 20)];
    sexL.font = [UIFont systemFontOfSize:12];
    sexL.text = @"性别：";
    sexL.textColor = [UIColor blackColor];
    sexL.textAlignment = NSTextAlignmentLeft;//右边显示
    UILabel *sexL2 = [[UILabel alloc]initWithFrame:CGRectMake(sexL.frame.origin.x+sexL.frame.size.width, sexL.frame.origin.y, 50, 20)];
    sexL2.font = [UIFont systemFontOfSize:12];
    sexL2.textColor = [UIColor colorWithRed:220/255.0 green:207/255.0 blue:197/255.0 alpha:1];
    self.sexLabel = sexL2;
    [self.view addSubview:sexL];
    [self.view addSubview:sexL2];
    
    //民族
    UILabel *forkL = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, self.idCardNumberLabel.frame.origin.y + self.idCardNumberLabel.frame.size.height + 35, 50, 20)];
    forkL.font = [UIFont systemFontOfSize:12];
    forkL.text = @"民族：";
    forkL.textColor = [UIColor blackColor];
    forkL.textAlignment = NSTextAlignmentLeft;//右边显示
    UILabel *forkL2 = [[UILabel alloc]initWithFrame:CGRectMake(forkL.frame.origin.x+forkL.frame.size.width, forkL.frame.origin.y, 50, 20)];
    forkL2.font = [UIFont systemFontOfSize:12];
    forkL2.textColor = [UIColor colorWithRed:220/255.0 green:207/255.0 blue:197/255.0 alpha:1];
    self.forkLabel = forkL2;
    [self.view addSubview:forkL];
    [self.view addSubview:forkL2];
    
    //出生日期
    UILabel *birthdayL = [[UILabel alloc]initWithFrame:CGRectMake(self.idCardNumberLabel.frame.origin.x, forkL.frame.origin.y+forkL.frame.size.height, 50, 20)];
    birthdayL.font = [UIFont systemFontOfSize:12];
    birthdayL.text = @"出生：";
    birthdayL.textColor = [UIColor blackColor];
    birthdayL.textAlignment = NSTextAlignmentLeft;//右边显示
    UILabel *birthdayL2 = [[UILabel alloc]initWithFrame:CGRectMake(birthdayL.frame.origin.x+birthdayL.frame.size.width, birthdayL.frame.origin.y, 180, 20)];
    birthdayL2.font = [UIFont systemFontOfSize:12];
    birthdayL2.textColor = [UIColor colorWithRed:220/255.0 green:207/255.0 blue:197/255.0 alpha:1];
    self.birthdayLabel = birthdayL2;
    [self.view addSubview:birthdayL];
    [self.view addSubview:birthdayL2];
    
    //住址
    UILabel *addressL = [[UILabel alloc]initWithFrame:CGRectMake(self.idCardNumberLabel.frame.origin.x, birthdayL.frame.origin.y+birthdayL.frame.size.height, 50, 40)];
    addressL.font = [UIFont systemFontOfSize:12];
    addressL.text = @"住址：";
    addressL.textColor = [UIColor blackColor];
    addressL.textAlignment = NSTextAlignmentLeft;//右边显示
    UILabel *addressL2 = [[UILabel alloc]initWithFrame:CGRectMake(addressL.frame.origin.x+addressL.frame.size.width, addressL.frame.origin.y, self.nameLabel.frame.size.width + self.nameTextField.frame.size.width - addressL.frame.size.width, 40)];
    addressL2.font = [UIFont systemFontOfSize:12];
    addressL2.numberOfLines = 0;
    addressL2.textColor = [UIColor colorWithRed:220/255.0 green:207/255.0 blue:197/255.0 alpha:1];
    self.addressLabel = addressL2;
    [self.view addSubview:addressL];
    [self.view addSubview:addressL2];
    
    
    //联网
    [self httpOcrService];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    // 偏移视图来保持软键盘开启时输入框区域可见
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -170);
    }];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    // 还原对视图的偏移
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}



-(void)textFiledEditChanged:(NSNotification *)obj
{

    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    if (toBeString.length > 18)
    {
        textField.text = [toBeString substringToIndex:18];
    }
}




//联网
-(void)httpOcrService
{
    
    
    UIImageView *tmpImageview =[[UIImageView alloc] init];
    self.tmpImageview = tmpImageview;
    self.tmpImageview.contentMode = UIViewContentModeScaleAspectFit;
    self.tmpImageview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tmpImageview.backgroundColor = [UIColor blackColor];
    self.tmpImageview.alpha = 0.5;
    [self.view addSubview:self.tmpImageview];
    
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height/2-80, 200, 50)];
    tmpLabel.textAlignment = NSTextAlignmentCenter;//居中显示
    tmpLabel.textColor = [UIColor yellowColor];
    tmpLabel.font = [UIFont systemFontOfSize:20];
    tmpLabel.text = @"OCR识别中";
    [tmpImageview addSubview:tmpLabel];
    
    
    //载入旋转
    UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.testActivityIndicator = testActivityIndicator;
    self.testActivityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-100);//设置中心
    [self.tmpImageview addSubview:self.testActivityIndicator];
    
    self.testActivityIndicator.color = [UIColor yellowColor]; // 改变颜色
    [self.testActivityIndicator startAnimating]; // 开始旋转
    
    
    //不允许交互
    self.view.userInteractionEnabled = NO;
    
    
    
    
    
    NSURL *postUrl = [[NSURL URLWithString:[[JYAVSessionHolder instance] serviceUrl]] URLByAppendingPathComponent:@"ocr"];
//    NSURL *postUrl = [NSURL URLWithString:@"http://192.168.1.69:9080/AuthAppServerProject3/ocr"];
    
    
    [[HttpService service] post:postUrl body:[self postBody] success:^(NSInteger statusCode, NSData *body) {
        NSError *error = nil;
        
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:body options:kNilOptions error:&error];
        if (error || dict == nil)
        {
            [self.testActivityIndicator stopAnimating]; // 结束旋转
            [self.testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
            [self.testActivityIndicator removeFromSuperview];
            self.testActivityIndicator = nil;
            [self.tmpImageview removeFromSuperview];
            self.tmpImageview = nil;
            //允许交互
            self.view.userInteractionEnabled = YES;
            
            [self messageBoxWithString:@"服务器错误"];
            return;
        }

        NSLog(@"%@",dict);
        
        NSString *info = [dict objectForKey:@"info"];
        
        NSInteger code = [[dict objectForKey:@"code"] integerValue];
        if (code == 0)
        {
            NSMutableDictionary *data = [dict objectForKey:@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                //姓名
                if ([data objectForKey:@"name"]) {
                    NSString *name = [data objectForKey:@"name"];
                    self.nameTextField.text = name;
                }

                //证件号
                if ([data objectForKey:@"certid"]) {
                    NSString *certid = [data objectForKey:@"certid"];
                    self.idCardNumberTextField.text = certid;
                }

                //性别
                if ([data objectForKey:@"sex"]) {
                    NSString *sex = [data objectForKey:@"sex"];
                    self.sexLabel.text = sex;
                }

                //生日
                if ([data objectForKey:@"birthday"]) {
                    NSString *birthday = [data objectForKey:@"birthday"];
                    self.birthdayLabel.text = birthday;
                }

                //民族
                if ([data objectForKey:@"fork"]) {
                    NSString *fork = [data objectForKey:@"fork"];
                    self.forkLabel.text = fork;
                }

                //地址
                if ([data objectForKey:@"address"]) {
                    NSString *address = [data objectForKey:@"address"];
                    self.addressLabel.text = address;
                }

            });
        }else{
            [self messageBoxWithString:info];
        }
        
        [self.testActivityIndicator stopAnimating]; // 结束旋转
        [self.testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        [self.testActivityIndicator removeFromSuperview];
        self.testActivityIndicator = nil;
        [self.tmpImageview removeFromSuperview];
        self.tmpImageview = nil;
        //允许交互
        self.view.userInteractionEnabled = YES;
        
    } fail:^(NSError *error) {
        [self.testActivityIndicator stopAnimating]; // 结束旋转
        [self.testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        [self.testActivityIndicator removeFromSuperview];
        self.testActivityIndicator = nil;
        [self.tmpImageview removeFromSuperview];
        self.tmpImageview = nil;
        //允许交互
        self.view.userInteractionEnabled = YES;
        
        [self messageBoxWithString:@"请检查网络"];
    }];
}

//弹窗
-(void)messageBoxWithString:(NSString *)string
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.delegate = self;
    
    // 2.显示在屏幕上
    [alert show];
}

//返回上传服务器的data
-(NSData*)postBody {
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    idCardAdoptMode *mode = [[idCardAdoptMode alloc] init];
    
    NSString *_page = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[mode.idCardData base64Encoding] , nil, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
    
    
    
//    NSLog(@"1===%@",encodedString);
//    NSLog(@"2===%@",[_page stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    [data appendData:[[@"front_photo=" stringByAppendingString:[_page stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [data appendData:[[NSString stringWithFormat:@"&strProjectNum=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"projectID"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return data;
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    

}


- (void)goBack
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ocrBack" object:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}


//下一步
- (void)next
{
    if (self.nameTextField.text.length == 0||self.idCardNumberTextField.text.length == 0) {
        [self messageBoxWithString:@"必须输入姓名和证件号"];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ocrExit" object:self];
    
    //返回，并发送通知，进入下一步
    //发通知
    idCardAdoptMode *model = [[idCardAdoptMode alloc] init];
    model.name = self.nameTextField.text;
    model.idCardNumber = self.idCardNumberTextField.text;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


//点击空白收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//点击return键后
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //收起键盘 （这句有效！）
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if (textField == self.nameTextField) {//如果是账号，跳转到密码
        [self.idCardNumberTextField becomeFirstResponder];//跳转光标到密码栏
    
    }else{
    
        [self.idCardNumberTextField resignFirstResponder];//如果是密码，退出键盘
    
        if (self.nameTextField.text.length==0||self.idCardNumberTextField.text.length==0) {
            //如果为空,弹窗 账号或密码格式错误
            [self messageBoxWithString:@"必须输入帐号或密码"];
        }
//        else if (self.idCardNumberTextField.text.length!=18)
//        {
//            [self messageBoxWithString:@"身份证号必须是18位"];
//
//        }
        else{
        //下一步
            NSLog(@"下一步");
            [self next];
        }
    }
    return YES;
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
