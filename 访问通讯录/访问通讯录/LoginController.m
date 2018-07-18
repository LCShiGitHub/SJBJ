//
//  ViewController.m
//  JYVivoApp
//
//  Created by jock li on 16/4/24.
//  Copyright © 2016年 timedge. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "LoginController.h"
#import "LoginTextField.h"
#import "CustomAccessoryView.h"
#import "IDInputView.h"
#import "Person.h"
#import "LoginCheckBox.h"
#import "idCardAdoptMode.h"
#import "RecognitionController.h"
#import "settingViewController.h"
#import "idCardViewController.h"




#define DISPLACEMENT_VIEW_HIGHT -170


@interface LoginController () <UITextFieldDelegate, CustomAccessoryViewDelegate,UIAlertViewDelegate>
{
//    NSMutableArray* _accessoryNameSources;
//    NSMutableArray* _accessoryIdSources;
}


@property (weak, nonatomic)  LoginTextField *loginNameField;
@property (weak, nonatomic)  LoginTextField *loginIDField;
//@property (strong, nonatomic) IBOutlet CustomAccessoryView *customAccessoryView;
//@property (strong, nonatomic) IBOutlet IDInputView *idInputView;
//@property (strong, nonatomic) IBOutlet Person *personInfo;

//登陆按钮属性
@property (strong, nonatomic) UIButton *loginBtn;

//记住密码控件属性
@property (strong, nonatomic) LoginCheckBox *loginCheckBox;

//请输入登录信息的控件属性
@property (strong, nonatomic) UILabel *titleLabel;


@property (strong, nonatomic) UITextField *nameTextF;
@property (strong, nonatomic) UITextField *cardTextF;

@end

@implementation LoginController



bool projectIDIsNil = YES;

static NSString *phoneNumber;

static NSString *password;




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noRememberView" object:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /////////////////
    //设定背景颜色
    [self.view setBackgroundColor:[UIColor colorWithRed:24/255.0 green:122/255.0 blue:196/255.0 alpha:1]];
    
    //背景图
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImgView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:backImgView];
    
    //顶部图片
    UIImageView *topImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 130)];
    topImgV.image = [UIImage imageNamed:@"LoginTop"];
//    [self.view addSubview:topImgV];
    
    //logo图片
    UIImageView *logoImgV = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 125)/2, 65, 125, 125)];
    logoImgV.image = [UIImage imageNamed:@"login_logo"];
//    [self.view addSubview:logoImgV];
    
    //请输入登录信息字样
    UILabel *titleLable = [[UILabel alloc ] initWithFrame:CGRectMake((self.view.frame.size.width-120)/2, topImgV.frame.origin.y + topImgV.frame.size.height +120 , 120, 20)];
    titleLable.text = @"请输入登录信息";
    titleLable.textAlignment = NSTextAlignmentCenter;//居中显示
    titleLable.font = [UIFont systemFontOfSize:15];
    [titleLable setTextColor:[UIColor whiteColor]];
    self.titleLabel = titleLable;
//    [self.view addSubview:titleLable];
    
    //人证一致字样
    UILabel *title2Lable =[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 120)/2, titleLable.frame.origin.y - 8 - 40, 120, 40)];
    title2Lable.text = @"人证一致";
    title2Lable.textAlignment = NSTextAlignmentCenter;//居中显示
    title2Lable.font = [UIFont systemFontOfSize:26];
    title2Lable.textColor =[UIColor whiteColor];
//    [self.view addSubview:title2Lable];
    
    //登录按钮
    UIButton *loginBtn =[[UIButton alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height - 80, self.view.frame.size.width - 100, 40)];
    self.loginBtn = loginBtn;
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:[UIColor colorWithRed:78/255.0 green:187/255.0 blue:195/255.0 alpha:1]];
    [self.view addSubview:loginBtn];
    
    //设置按钮
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, self.view.frame.size.height - 8 - 30, 30, 30)];
    [settingBtn setImage:[UIImage imageNamed:@"btn_setting_n"] forState:UIControlStateNormal];
    [settingBtn addTarget:self  action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    //姓名输入框
    LoginTextField *loginNameField = [[LoginTextField alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/5*3, self.view.frame.size.width - 20 - 20, 43)];
    loginNameField.tag = 11;
    loginNameField.labelText = @"姓名";
    loginNameField.delegate = self;
    self.loginNameField = loginNameField;
    
    
    //证件号输入框
    LoginTextField *loginIDField = [[LoginTextField alloc] initWithFrame:CGRectMake(20, loginNameField.frame.size.height + loginNameField.frame.origin.y + 25, self.view.frame.size.width - 20 - 20, 43)];
    loginIDField.tag = 10;
    loginIDField.delegate = self;
    loginIDField.labelText = @"身份证";
    self.loginIDField = loginIDField;
//    [self.view addSubview:loginIDField];
    
    //记住密码
    LoginCheckBox *loginCheckBox = [[LoginCheckBox alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120 - 20, loginIDField.frame.origin.y + loginIDField.frame.size.height +23, 120, 40)];
    self.loginCheckBox = loginCheckBox;
//    [self.view addSubview:loginCheckBox];
    
    //放在最下面添加，保证记住账号栏不被遮挡
//    [self.view addSubview:loginNameField];
    
    
    //姓名输入框
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height/5*3, self.view.frame.size.width - 100, 30)];
    nameView.backgroundColor = [UIColor clearColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, nameView.frame.size.height - 1, nameView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [nameView addSubview:lineView];
    UIImageView *nameImgView = [[UIImageView alloc] initWithFrame:CGRectMake(nameView.frame.size.height/6, nameView.frame.size.height/6, nameView.frame.size.height/3*2, nameView.frame.size.height/3*2)];
    nameImgView.image = [UIImage imageNamed:@"icon_name"];
    [nameView addSubview:nameImgView];
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(nameView.frame.size.height - 1, 0, 1, nameView.frame.size.height - 1)];
    lineView2.backgroundColor = [UIColor whiteColor];
    [nameView addSubview:lineView2];
    UITextField *nameTextF = [[UITextField alloc] initWithFrame:CGRectMake(lineView2.frame.origin.x +1, 0, nameView.frame.size.width - (nameView.frame.size.height), nameView.frame.size.height - 1)];
    nameTextF.delegate = self;
    self.nameTextF = nameTextF;
    [nameView addSubview:nameTextF];
//    [self.view addSubview:nameView];
    
    
    //证件输入框
    UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(50, nameView.frame.size.height + nameView.frame.origin.y + 25, self.view.frame.size.width - 100, 30)];
    cardView.backgroundColor = [UIColor clearColor];
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, cardView.frame.size.height - 1, nameView.frame.size.width, 1)];
    line2View.backgroundColor = [UIColor whiteColor];
    [cardView addSubview:line2View];
    UIImageView *cardImgView = [[UIImageView alloc] initWithFrame:CGRectMake((cardView.frame.size.height/6), cardView.frame.size.height/6, cardView.frame.size.height/3*2, cardView.frame.size.height/3*2)];
    cardImgView.image = [UIImage imageNamed:@"icon_password"];
    [cardView addSubview:cardImgView];
    UIView *line2View2 = [[UIView alloc] initWithFrame:CGRectMake(cardView.frame.size.height - 1, 0, 1, cardView.frame.size.height - 1)];
    line2View2.backgroundColor = [UIColor whiteColor];
    [cardView addSubview:line2View2];
    UITextField *cardTextF = [[UITextField alloc] initWithFrame:CGRectMake(line2View2.frame.origin.x +1, 0, nameView.frame.size.width - cardView.frame.size.height, cardView.frame.size.height - 1)];
    cardTextF.delegate = self;
    cardTextF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;//键盘类型
    self.cardTextF = cardTextF;
//    [cardView addSubview:cardTextF];
//    [self.view addSubview:cardView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:self.cardTextF];
    
    /////////////////
    
    
//    // 初始化设置
//    self.loginNameField.textField.inputAccessoryView = self.customAccessoryView;
//    [self.loginNameField.textField addTarget:self action:@selector(onNameChanged:) forControlEvents:UIControlEventEditingChanged];
//    self.loginIDField.textField.inputView = self.idInputView;
//    self.idInputView.textField = self.loginIDField.textField;
//    self.loginIDField.textField.inputAccessoryView = self.customAccessoryView;
//    [self.loginIDField.textField addTarget:self action:@selector(onIdChanged:) forControlEvents:UIControlEventEditingChanged];
    
    // 为输入提取备选文字数组
//    _accessoryNameSources = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"names"]];
//    _accessoryIdSources = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"ids"]];
//    if (_accessoryNameSources == nil) {
//        _accessoryNameSources = [NSMutableArray new];
//    }
//    if (_accessoryIdSources == nil) {
//        _accessoryIdSources = [NSMutableArray new];
//    }

    //登陆按钮圆角
    self.loginBtn.layer.cornerRadius = 20;
    self.loginBtn.layer.masksToBounds = YES;
    
    self.loginIDField.layer.cornerRadius = 0;
    self.loginIDField.layer.masksToBounds = YES;
    
    
    idCardAdoptMode *mode = [[idCardAdoptMode alloc] init];
    mode.numberOne = 0;
    
    //左边的白线
    UIView *leftLineView = [[UIView alloc]initWithFrame:CGRectMake(20, self.titleLabel.frame.origin.y +(self.titleLabel.frame.size.height/2),self.titleLabel.frame.origin.x - 20, 2)];
    leftLineView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:leftLineView];
    
    //右边的白线
    UIView *rightLineView = [[UIView alloc]initWithFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width  ,self.titleLabel.frame.origin.y +(self.titleLabel.frame.size.height/2) ,self.view.frame.size.width-40 - self.titleLabel.frame.size.width -(self.titleLabel.frame.origin.x - 20), 2)];
    rightLineView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:rightLineView];
    
}



//进入设置
-(void)setting
{
    settingViewController *settingVC = [[settingViewController alloc] init];
    
    UINavigationController *navigationC = [[UINavigationController alloc] initWithRootViewController:settingVC];
    
    //跳转
    [self presentViewController:navigationC animated:YES completion:nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.loginCheckBox.rememberPassword == YES)
    {
        if (self.loginNameField.textField.text.length == 0)
        {
            self.loginNameField.textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name:NO.1"];
            
            self.loginIDField.textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password:NO.1"];//密码
        }
        if(self.loginIDField.textField.text.length != 0)
        {
            self.loginIDField.deleteTxtBtn.alpha = 1;
        }
    }else
    {
        if (phoneNumber!=nil&&password!=nil)
        {
            self.loginNameField.textField.text = phoneNumber;
            
            self.loginIDField.textField.text = password;
            if(self.loginIDField.textField.text.length != 0)
            {
                self.loginIDField.deleteTxtBtn.alpha = 1;
            }
        }
    }
}

// 过滤源数组
- (NSArray*)getOptions:(NSArray*)source filter:(NSString*)filter
{
    NSMutableArray *array = [NSMutableArray new];
    for (NSString* item in source)
    {
        if ([item hasPrefix:filter])
        {
            [array addObject:item];
        }
    }
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    return array;
}


- (void)closeKeyboard
{
    idCardAdoptMode *mode = [[idCardAdoptMode alloc] init];
    mode.writingIdNumber = NO;
    
    if (self.loginNameField.textField.isFirstResponder) {
        [self.loginNameField.textField resignFirstResponder];
    } else if(self.loginIDField.textField.isFirstResponder) {
        [self.loginIDField.textField resignFirstResponder];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    // 偏移视图来保持软键盘开启时输入框区域可见
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, DISPLACEMENT_VIEW_HIGHT);
    }];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {

    idCardAdoptMode *mode = [[idCardAdoptMode alloc] init];
    mode.writingIdNumber = NO;
    
    // 还原对视图的偏移
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 设置回车行为
    if (self.nameTextF == textField)
    {
        
        [self.cardTextF becomeFirstResponder];
        
        
    } else if(self.cardTextF == textField)
    {
        //收回键盘
//        [self.view endEditing:YES];
        
        [self.cardTextF resignFirstResponder];
    }
    return NO;
}


-(void)customAccessoryView:(CustomAccessoryView *)customAccessoryView selectedOption:(NSString *)option
{
    
    if (self.loginNameField.textField.isFirstResponder)
    {
        self.loginNameField.textField.text = option;
    } else if(self.loginIDField.textField.isFirstResponder)
    {
        self.loginIDField.textField.text = option;
        if(self.loginIDField.textField.text.length != 0)
        {
            self.loginIDField.deleteTxtBtn.alpha = 1;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)showError:(NSString*)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}



- (void)saveOptionsIfNeed:(NSString*)option to:(NSMutableArray*)target saveKey:(NSString*)key
{
    if (![target containsObject:option])
    {
        [target addObject:option];
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:target forKey:key];
        [userDefaults synchronize];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //setUp
        [self setting];
    }
    else if(buttonIndex == 1)
    {
        //登陆
        projectIDIsNil = NO;
    }
}


//登陆
- (BOOL)login
{
    idCardAdoptMode *mode = [[idCardAdoptMode alloc] init];
    
    mode.writingIdNumber = NO;
    
    
//        // 判断登录情况
//        if(self.nameTextF.text.length == 0)
//        {
//            [self showError:@"请填写姓名"];
//            return NO;
//        }
//        if(self.cardTextF.text.length == 0)
//        {
//            [self showError:@"请填写身份证"];
//            return NO;
//        }
//        if(self.cardTextF.text.length != 18)
//        {
//            [self showError:@"身份证必须是 18 位"];
//            return NO;
//        }
        
        NSString *projectID = [[NSUserDefaults standardUserDefaults] objectForKey:@"projectID"];
        
        
        bool projectIDExist = YES;
        
        if ([projectID  isEqual: @""] || projectID == (NULL))
            projectIDExist = NO;
        
        
        if (projectIDExist == NO && projectIDIsNil == YES) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您未填写“项目ID”,无法联网检测,是否跳转并设置“项目ID”?" delegate:self cancelButtonTitle:@"去设置" otherButtonTitles:@"继续检测", nil];
            alert.delegate = self;
            [alert show];                   //弹出提示窗（二选一）
            return NO;
        }
        projectIDIsNil = YES;
    
    //获取到控制器
    idCardViewController *idCardVC = [[idCardViewController alloc] init];  //RecognitionController
    //跳转
    [self presentViewController:idCardVC animated:YES completion:nil];
    
    phoneNumber = self.nameTextF.text;
        
    password = self.cardTextF.text;
    
//    mode.idCardNumber = self.cardTextF.text;
//    
//    mode.name = self.nameTextF.text;
    
    mode.severalController = 0;
        
    return YES;

}


-(void)textFiledEditChanged:(NSNotification *)obj
{
    //正在输入密码
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    if (toBeString.length > 18 && self.cardTextF == textField)
    {
        textField.text = [toBeString substringToIndex:18];
    }
}


// 用于在结果页面直接导航返回到本页面的 segue 点
- (IBAction)unwindSegueToLoginController:(UIStoryboardSegue*)segue
{
    
}

@end
