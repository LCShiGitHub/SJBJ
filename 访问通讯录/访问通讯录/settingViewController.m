//
//  settingViewController.m
//  JYVivoUI2
//
//  Created by junyufr on 16/9/30.
//  Copyright © 2016年 timedge. All rights reserved.
//

#import "settingViewController.h"
#import "JYAVSessionHolder.h"


@interface settingViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (strong,nonatomic) UITextField *projectID;


@property(strong,nonatomic) UIView *downView;

@property(strong,nonatomic) UIView *phtotNumberView;

@property(strong,nonatomic) UITextView *textView;

@property(strong,nonatomic) NSMutableArray *cellArray;


@property(strong,nonatomic) UISwitch *oneSwitchView;
@property(strong,nonatomic) UISwitch *twoSwitchView;
@property(strong,nonatomic) UISwitch *threeSwitchView;


//***改 增
@property(strong,nonatomic) UIView *actionNumberView;
@property(strong,nonatomic) UISwitch *oneSwitchView2;
@property(strong,nonatomic) UISwitch *twoSwitchView2;
@property(strong,nonatomic) UISwitch *threeSwitchView2;

@property(strong,nonatomic) UIView *actionDifficultyView;
@property(strong,nonatomic) UISwitch *oneSwitchView3;
@property(strong,nonatomic) UISwitch *twoSwitchView3;
@property(strong,nonatomic) UISwitch *threeSwitchView3;


@property(strong,nonatomic) UIView *actionSelectView;
@property(strong,nonatomic) UIButton *oneSwitchView1;
@property(strong,nonatomic) UIButton *twoSwitchView1;
@property(strong,nonatomic) UIButton *threeSwitchView1;

@property(strong,nonatomic) UITableViewCell *actionSelectCell;//动作选择Cell
@property(strong,nonatomic) UITableViewCell *actionNumbersCell;//动作次数Cell
@property(strong,nonatomic) UITableViewCell *actionDifficultyCell;//完成难度



@end

@implementation settingViewController


-(NSMutableArray *)cellArray
{
    if (_cellArray == nil)
    {
        
        NSMutableArray *array = [NSMutableArray array];
        
        _cellArray = array;
        
    }
    return _cellArray;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    //返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemStop target:self action:@selector(touchBackBtn)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.projectID = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 150 - 30, 15 ,150, 30)];
    self.projectID.borderStyle = UITextBorderStyleRoundedRect;
    self.projectID.placeholder = @"请输入项目ID";
    
    self.projectID.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"projectID"];
    
    self.projectID.returnKeyType =UIReturnKeyDone;
    self.projectID.delegate = self;
    
    //取消分割线
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    
}

//点击return键后
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.projectID.text forKey:@"projectID"];
    
    return YES;
}


//返回按钮
-(void)touchBackBtn
{
    
    [[NSUserDefaults standardUserDefaults] setObject:self.projectID.text forKey:@"projectID"];
    
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

//***改 设置每组数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return 4;
    }
    else if(section == 1)
    {
        return 2;
    }else
        return 3;
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//设置分组的行高
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

//***改 自定义分组view  ***
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return [self setSecitonView:@"功能设置"];
    }
    else if(section == 1)
    {
        return [self setSecitonView:@"版本信息"];
    }else
    {
        return [self setSecitonView:@"检测调节"];
    }
}

//分组view自定义
-(UIView *)setSecitonView:(NSString *)titile
{
    UIView * myView = [[UIView alloc] init] ;
    myView.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:0.7];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 22)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text=titile;
    [myView addSubview:titleLabel];
    return myView;
}

-(void)touchTrueBtn
{
    //确定
    [[JYAVSessionHolder instance] setServiceUrl:self.textView.text];
    [self closeDownView];
}

-(void)touchFalseBtn
{
    //取消
    [self closeDownView];
}

-(void)closeDownView
{
    self.downView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.downView.transform = CGAffineTransformRotate(self.downView.transform, M_PI);
        
        self.downView.frame = CGRectMake(self.tableView.frame.size.width, -300, 200, 170);
        
    } completion:^(BOOL finished)
     {
         self.downView.transform = CGAffineTransformIdentity;
         
         for (UITableViewCell *cell in self.cellArray)
         {
             cell.userInteractionEnabled = YES;
         }
         self.textView.text = [[JYAVSessionHolder instance] serviceUrl];
         
     }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0&&indexPath.section == 0) {
        cell.textLabel.text = @"服务器URL";
        cell.detailTextLabel.text = @"设置后台服务器地址";
    }
    else if(indexPath.row == 1&&indexPath.section == 0) {
        cell.textLabel.text = @"项目ID";
        cell.detailTextLabel.text = @"设置项目编号";
        [cell.contentView addSubview:self.projectID];
    }
    else if (indexPath.row == 2&&indexPath.section == 0) {
        cell.textLabel.text = @"保存照片";//获取文件名
        cell.detailTextLabel.text = @"设置保存活体照片数量";
    }
    else if(indexPath.row == 3&&indexPath.section == 0) {
        cell.textLabel.text = @"倒计时声音";//获取文件名
        [cell.contentView addSubview:[self newSwitch]];
        cell.detailTextLabel.text = @"设置倒计时";
    }
    else if(indexPath.row == 0&&indexPath.section == 1) {
        cell.textLabel.text = @"版本控制信息";//获取文件名
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.text =[NSString stringWithFormat:@"%@\n%@",[[JYAVSessionHolder instance] libVersion],[[JYAVSessionHolder instance] projectName]];
        
        
    }
    else if(indexPath.row == 1&&indexPath.section == 1) {
        cell.textLabel.text = @"APP版本号";//获取文件名
        cell.detailTextLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }
    
    //加入
    else if (indexPath.row == 0&&indexPath.section == 2)
    {
        cell.textLabel.text = @"动作选择";
        self.actionSelectCell = cell;
        
        
        //获取当下所选的动作
        NSString *actionStr = @"";
        
        NSString *actionSelectOne = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionSelectOne"];//获取
        NSString *actionSelectTwo = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionSelectTwo"];//获取
        NSString *actionSelectThree = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionSelectThree"];//获取
        
        if ([actionSelectOne  isEqual: @"YES"] || actionSelectOne == nil || [actionSelectOne  isEqual: @""])
        {
            actionStr =[actionStr stringByAppendingString:@"眨眼   "];
        }
        if ([actionSelectTwo  isEqual: @"YES"] || actionSelectTwo == nil || [actionSelectTwo  isEqual: @""])
        {
            actionStr =[actionStr stringByAppendingString:@"张嘴   "];
            
        }
        if ([actionSelectThree  isEqual: @"YES"] || actionSelectThree == nil || [actionSelectThree  isEqual: @""]) {
            actionStr =[actionStr stringByAppendingString:@"抬头"];
        }
        
        cell.detailTextLabel.text = actionStr;
        cell.detailTextLabel.textColor = [UIColor blueColor];
        
    }
    else if (indexPath.row == 1&&indexPath.section == 2)
    {
        cell.textLabel.text = @"执行次数";
        self.actionNumbersCell = cell;
        NSString *actionNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionNumber"];//获取
        if (actionNumber != nil && ![actionNumber  isEqual: @""]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"目前：%@ 次",actionNumber];
        }else
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"目前：3 次"];
        }
        cell.detailTextLabel.textColor = [UIColor blueColor];
        
    }
    else if (indexPath.row == 2&&indexPath.section == 2)
    {
        cell.textLabel.text = @"完成难度";
        
        self.actionDifficultyCell = cell;
        
        NSString *actionNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionDifficulty"];
        
        if ([actionNumber  isEqual: @"1"])
        {
            cell.detailTextLabel.text = @"目前：简单";
        }
        else if ([actionNumber  isEqual: @"2"] || actionNumber == nil || [actionNumber  isEqual: @""])
        {
            cell.detailTextLabel.text = @"目前：普通";
        }
        else if ([actionNumber  isEqual: @"3"])
        {
            cell.detailTextLabel.text = @"目前：困难";
        }else
            cell.detailTextLabel.text = @"目前：普通";
        
        cell.detailTextLabel.textColor = [UIColor blueColor];
    }
    
    [self.cellArray addObject:cell];
    
    return cell;
}

//监听点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        //服务器url
        [self settingProjectUrl];
    }
    else if(indexPath.row == 2 && indexPath.section == 0)
    {
        [self settingPhotoNumbers];

    }
    //加入
    else if(indexPath.row == 0 && indexPath.section == 2)
    {
        //动作选择
        [self settingActionSelect];
    }
    else if(indexPath.row == 1 && indexPath.section == 2)
    {
        //执行次数
        [self settingActionNumbers];
    }
    else if(indexPath.row == 2 && indexPath.section == 2)
    {
        //完成难度
        [self settingActionDifficulty];
    }
    
}


//***改 增 动作选择弹窗
-(void)settingActionSelect
{
    [self.view endEditing:YES];
    
    //弹窗
    if (self.actionSelectView == nil) {
        UIView *actionSelectView = [[UIView alloc] init];
        
        self.actionSelectView = actionSelectView;
        
        self.actionSelectView.backgroundColor = [UIColor blackColor];
        
        //标题
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 40)];
        
        label.text = @"动作选择";
        
        label.textAlignment = NSTextAlignmentCenter;//居中显示
        
        label.font = [UIFont systemFontOfSize:18];
        
        label.textColor = [UIColor whiteColor];
        
        label.backgroundColor = self.actionSelectView.backgroundColor;
        
        [self.actionSelectView addSubview:label];
        
        //确定完成按钮
        UIButton *trueBtn= [[UIButton alloc] initWithFrame:CGRectMake((200-80)/2, 145, 80, 20)]; //确定
        
        [trueBtn setTitle:@"确定" forState:UIControlStateNormal];
        trueBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [trueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [trueBtn addTarget:self action:@selector(closeActionSelectView) forControlEvents:UIControlEventTouchDown];
        
        
        UILabel *oneL = [[UILabel alloc] initWithFrame:CGRectMake(5, label.frame.size.height, 120, 30)];
        oneL.text = @"眨眼";
        oneL.textColor = [UIColor whiteColor];
        
        UILabel *twoL = [[UILabel alloc] initWithFrame:CGRectMake(5, oneL.frame.size.height + oneL.frame.origin.y +5, 120, 30)];
        twoL.text = @"张嘴";
        twoL.textColor = [UIColor whiteColor];
        
        UILabel *threeL = [[UILabel alloc] initWithFrame:CGRectMake(5, twoL.frame.size.height + twoL.frame.origin.y +5, 120, 30)];
        threeL.text = @"抬头";
        threeL.textColor = [UIColor whiteColor];
        
        [actionSelectView addSubview:oneL];
        [actionSelectView addSubview:twoL];
        [actionSelectView addSubview:threeL];
        
        NSString *actionSelectOne = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionSelectOne"];//获取
        NSString *actionSelectTwo = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionSelectTwo"];//获取
        NSString *actionSelectThree = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionSelectThree"];//获取
        
        //第一个按钮
        UIButton *oneSwitchView = [[UIButton alloc] initWithFrame:CGRectMake(155, oneL.frame.origin.y, 30, 30)];
        self.oneSwitchView1 = oneSwitchView;
        [oneSwitchView setImage:[UIImage imageNamed:@"com_check_red"] forState:UIControlStateNormal];
        [oneSwitchView setImage:[UIImage imageNamed:@"com_check_selected_red"] forState:UIControlStateSelected];
        if ([actionSelectOne  isEqual: @"YES"]||[actionSelectOne  isEqual: @""]||actionSelectOne == nil)
        {
            oneSwitchView.selected = YES;
        }else
        {
            oneSwitchView.selected = NO;
        }
        [oneSwitchView addTarget:self action:@selector(switchOne1) forControlEvents:UIControlEventTouchDown];
        
        //第二个按钮
        UIButton *twoSwitchView = [[UIButton alloc] initWithFrame:CGRectMake(155, twoL.frame.origin.y, 30, 30)];
        self.twoSwitchView1 = twoSwitchView;
        [twoSwitchView setImage:[UIImage imageNamed:@"com_check_red"] forState:UIControlStateNormal];
        [twoSwitchView setImage:[UIImage imageNamed:@"com_check_selected_red"] forState:UIControlStateSelected];
        if ([actionSelectTwo  isEqual: @"YES"]||[actionSelectTwo  isEqual: @""]||actionSelectTwo == nil)
        {
            twoSwitchView.selected = YES;
        }else
        {
            twoSwitchView.selected = NO;
        }
        [twoSwitchView addTarget:self action:@selector(switchTwo1) forControlEvents:UIControlEventTouchDown];
        
        //第三个按钮
        UIButton *threeSwitchView = [[UIButton alloc] initWithFrame:CGRectMake(155, threeL.frame.origin.y, 30, 30)];
        self.threeSwitchView1 = threeSwitchView;
        [threeSwitchView setImage:[UIImage imageNamed:@"com_check_red"] forState:UIControlStateNormal];
        [threeSwitchView setImage:[UIImage imageNamed:@"com_check_selected_red"] forState:UIControlStateSelected];
        if ([actionSelectThree  isEqual: @"YES"]||[actionSelectThree  isEqual: @""]||actionSelectThree == nil)
        {
            threeSwitchView.selected = YES;
        }else
        {
            threeSwitchView.selected = NO;
        }
        [threeSwitchView addTarget:self action:@selector(switchThree1) forControlEvents:UIControlEventTouchDown];
        
        [actionSelectView addSubview:oneSwitchView];
        [actionSelectView addSubview:twoSwitchView];
        [actionSelectView addSubview:threeSwitchView];
        
        
        
        trueBtn.backgroundColor = [UIColor whiteColor];
        
        self.actionSelectView.layer.cornerRadius = 5;
        self.actionSelectView.layer.masksToBounds = YES;
        
        trueBtn.layer.cornerRadius = 5;
        trueBtn.layer.masksToBounds = YES;
        
        [self.actionSelectView addSubview:trueBtn];
        
        [self.view addSubview:self.actionSelectView];
        
    }
    //重新设定位置
    
    self.actionSelectView.frame = CGRectMake(-200, -300, 200, 170);
    
    self.tableView.scrollEnabled = NO;
    
    for (UITableViewCell *cell in self.cellArray)
    {
        cell.userInteractionEnabled = NO;
    }
    
    self.actionSelectView.transform = CGAffineTransformRotate(self.actionSelectView.transform, M_PI);
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.actionSelectView.transform = CGAffineTransformRotate(self.actionSelectView.transform, M_PI);
        
        self.actionSelectView.frame = CGRectMake(self.view.frame.size.width/2-100, 100, 200, 170);
        
    } completion:^(BOOL finished)
     {
         self.actionSelectView.transform = CGAffineTransformIdentity;
         
         self.actionSelectView.userInteractionEnabled = YES;
         self.tableView.scrollEnabled = YES;
     }];
}

//***改 增 点击动作选择窗口的确定按钮
-(void)closeActionSelectView
{
    self.actionSelectView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.actionSelectView.transform = CGAffineTransformRotate(self.actionSelectView.transform, M_PI);
        
        self.actionSelectView.frame = CGRectMake(self.tableView.frame.size.width, -300, 200, 170);
        
    } completion:^(BOOL finished)
     {
         self.actionSelectView.transform = CGAffineTransformIdentity;
         
         for (UITableViewCell *cell in self.cellArray)
         {
             cell.userInteractionEnabled = YES;
         }
         NSString *actionStr = @"";
         
         NSString *actionSelectOne = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionSelectOne"];//获取
         NSString *actionSelectTwo = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionSelectTwo"];//获取
         NSString *actionSelectThree = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionSelectThree"];//获取
         
         if ([actionSelectOne  isEqual: @"YES"] || actionSelectOne == nil || [actionSelectOne  isEqual: @""])
         {
             actionStr =[actionStr stringByAppendingString:@"眨眼   "];
         }
         if ([actionSelectTwo  isEqual: @"YES"] || actionSelectTwo == nil || [actionSelectTwo  isEqual: @""])
         {
             actionStr =[actionStr stringByAppendingString:@"张嘴   "];
             
         }
         if ([actionSelectThree  isEqual: @"YES"] || actionSelectThree == nil || [actionSelectThree  isEqual: @""]) {
             actionStr =[actionStr stringByAppendingString:@"抬头"];
         }
         
         self.actionSelectCell.detailTextLabel.text = actionStr;
         self.actionSelectCell.detailTextLabel.textColor = [UIColor blueColor];
     }];
}

//***改 增
-(void)switchOne1
{
    if (self.twoSwitchView1.selected == NO && self.threeSwitchView1.selected == NO) {
        return;
    }
    
    if (self.oneSwitchView1.selected == NO) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"actionSelectOne"];//设定
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"actionSelectOne"];//设定
    }
    self.oneSwitchView1.selected = !self.oneSwitchView1.selected;
}

//***改 增
-(void)switchTwo1
{
    if (self.oneSwitchView1.selected == NO && self.threeSwitchView1.selected == NO) {
        return;
    }
    
    if (self.twoSwitchView1.selected == NO) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"actionSelectTwo"];//设定
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"actionSelectTwo"];//设定
    }
    
    self.twoSwitchView1.selected = !self.twoSwitchView1.selected;
}

//***改 增
-(void)switchThree1
{
    if (self.oneSwitchView1.selected == NO && self.twoSwitchView1.selected == NO) {
        return;
    }
    
    if (self.threeSwitchView1.selected == NO) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"actionSelectThree"];//设定
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"actionSelectThree"];//设定
    }
    
    self.threeSwitchView1.selected = !self.threeSwitchView1.selected;
}


//***改 增 完成难度弹窗
-(void)settingActionDifficulty
{
    [self.view endEditing:YES];
    
    //弹窗
    if (self.actionDifficultyView == nil) {
        UIView *actionDifficultyView = [[UIView alloc] init];
        
        self.actionDifficultyView = actionDifficultyView;
        
        self.actionDifficultyView.backgroundColor = [UIColor blackColor];
        
        
        //标题
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 40)];
        
        label.text = @"完成难度";
        
        label.textAlignment = NSTextAlignmentCenter;//居中显示
        
        label.font = [UIFont systemFontOfSize:18];
        
        label.textColor = [UIColor whiteColor];
        
        label.backgroundColor = self.actionDifficultyView.backgroundColor;
        
        [self.actionDifficultyView addSubview:label];
        
        //确定完成按钮
        UIButton *trueBtn= [[UIButton alloc] initWithFrame:CGRectMake((200-80)/2, 145, 80, 20)]; //确定
        
        [trueBtn setTitle:@"确定" forState:UIControlStateNormal];
        trueBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [trueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [trueBtn addTarget:self action:@selector(closeActionDifficultyView) forControlEvents:UIControlEventTouchDown];
        
        
        UILabel *oneL = [[UILabel alloc] initWithFrame:CGRectMake(5, label.frame.size.height, 120, 30)];
        oneL.text = @"简单";
        oneL.textColor = [UIColor whiteColor];
        
        UILabel *twoL = [[UILabel alloc] initWithFrame:CGRectMake(5, oneL.frame.size.height + oneL.frame.origin.y +5, 120, 30)];
        twoL.text = @"普通";
        twoL.textColor = [UIColor whiteColor];
        
        UILabel *threeL = [[UILabel alloc] initWithFrame:CGRectMake(5, twoL.frame.size.height + twoL.frame.origin.y +5, 120, 30)];
        threeL.text = @"困难";
        threeL.textColor = [UIColor whiteColor];
        
        [actionDifficultyView addSubview:oneL];
        [actionDifficultyView addSubview:twoL];
        [actionDifficultyView addSubview:threeL];
        
        NSString *actionNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionDifficulty"];//获取
        
        //第一个按钮
        UISwitch *oneSwitchView = [[UISwitch alloc] initWithFrame:CGRectMake(135, oneL.frame.origin.y, 50, 30)];
        self.oneSwitchView3 = oneSwitchView;
        if ([actionNumber  isEqual: @"1"])
        {
            oneSwitchView.on = YES;
        }else
        {
            oneSwitchView.on = NO;
        }
        [oneSwitchView addTarget:self action:@selector(switchOne3) forControlEvents:UIControlEventValueChanged];
        
        //第二个按钮
        UISwitch *twoSwitchView = [[UISwitch alloc] initWithFrame:CGRectMake(135, twoL.frame.origin.y, 50, 30)];
        self.twoSwitchView3 = twoSwitchView;
        if ([actionNumber  isEqual: @"2"]||[actionNumber  isEqual: @""]||actionNumber == nil)
        {
            twoSwitchView.on = YES;
        }else
        {
            twoSwitchView.on = NO;
        }
        [twoSwitchView addTarget:self action:@selector(switchTwo3) forControlEvents:UIControlEventValueChanged];
        
        //第三个按钮
        UISwitch *threeSwitchView = [[UISwitch alloc] initWithFrame:CGRectMake(135, threeL.frame.origin.y, 50, 30)];
        self.threeSwitchView3 = threeSwitchView;
        if ([actionNumber  isEqual: @"3"])
        {
            threeSwitchView.on = YES;
        }else
        {
            threeSwitchView.on = NO;
        }
        [threeSwitchView addTarget:self action:@selector(switchThree3) forControlEvents:UIControlEventValueChanged];
        
        [actionDifficultyView addSubview:oneSwitchView];
        [actionDifficultyView addSubview:twoSwitchView];
        [actionDifficultyView addSubview:threeSwitchView];
        
        
        
        trueBtn.backgroundColor = [UIColor whiteColor];
        
        self.actionDifficultyView.layer.cornerRadius = 5;
        self.actionDifficultyView.layer.masksToBounds = YES;
        
        trueBtn.layer.cornerRadius = 5;
        trueBtn.layer.masksToBounds = YES;
        
        [self.actionDifficultyView addSubview:trueBtn];
        
        [self.view addSubview:self.actionDifficultyView];
        
    }
    //重新设定位置
    
    self.actionDifficultyView.frame = CGRectMake(-200, -300, 200, 170);
    
    self.tableView.scrollEnabled = NO;
    
    for (UITableViewCell *cell in self.cellArray)
    {
        cell.userInteractionEnabled = NO;
    }
    
    self.actionDifficultyView.transform = CGAffineTransformRotate(self.actionDifficultyView.transform, M_PI);
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.actionDifficultyView.transform = CGAffineTransformRotate(self.actionDifficultyView.transform, M_PI);
        
        self.actionDifficultyView.frame = CGRectMake(self.view.frame.size.width/2-100, 100, 200, 170);
        
    } completion:^(BOOL finished)
     {
         self.actionDifficultyView.transform = CGAffineTransformIdentity;
         
         self.actionDifficultyView.userInteractionEnabled = YES;
         self.tableView.scrollEnabled = YES;
     }];
}

//***改 增 点击完成难度窗口的确定按钮
-(void)closeActionDifficultyView
{
    self.actionDifficultyView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.actionDifficultyView.transform = CGAffineTransformRotate(self.actionDifficultyView.transform, M_PI);
        
        self.actionDifficultyView.frame = CGRectMake(self.tableView.frame.size.width, -300, 200, 170);
        
    } completion:^(BOOL finished)
     {
         self.actionDifficultyView.transform = CGAffineTransformIdentity;
         
         for (UITableViewCell *cell in self.cellArray)
         {
             cell.userInteractionEnabled = YES;
         }
         
     }];
}

//***改 增
-(void)switchOne3
{
    
    self.twoSwitchView3.on = NO;
    self.threeSwitchView3.on = NO;
    self.oneSwitchView3.on = YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"actionDifficulty"];//设定
    self.actionDifficultyCell.detailTextLabel.text = @"目前：简单";
}

//***改 增
-(void)switchTwo3
{
    self.oneSwitchView3.on = NO;
    self.threeSwitchView3.on = NO;
    self.twoSwitchView3.on = YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"actionDifficulty"];//设定
    self.actionDifficultyCell.detailTextLabel.text = @"目前：普通";
}

//***改 增
-(void)switchThree3
{
    self.oneSwitchView3.on = NO;
    self.twoSwitchView3.on = NO;
    self.threeSwitchView3.on = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"actionDifficulty"];//设定
    self.actionDifficultyCell.detailTextLabel.text = @"目前：困难";
}



//***改 增 执行次数弹窗
-(void)settingActionNumbers
{
    [self.view endEditing:YES];
    
    //弹窗
    if (self.actionNumberView == nil) {
        UIView *actionNumberView = [[UIView alloc] init];
        
        self.actionNumberView = actionNumberView;
        
        self.actionNumberView.backgroundColor = [UIColor blackColor];
        
        
        //标题
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 40)];
        
        label.text = @"动作次数";
        
        label.textAlignment = NSTextAlignmentCenter;//居中显示
        
        label.font = [UIFont systemFontOfSize:18];
        
        label.textColor = [UIColor whiteColor];
        
        label.backgroundColor = self.actionNumberView.backgroundColor;
        
        [self.actionNumberView addSubview:label];
        
        //确定取消按钮
        UIButton *trueBtn= [[UIButton alloc] initWithFrame:CGRectMake((200-80)/2, 145, 80, 20)];
        
        [trueBtn setTitle:@"确定" forState:UIControlStateNormal];
        trueBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [trueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [trueBtn addTarget:self action:@selector(closeActionNumberView) forControlEvents:UIControlEventTouchDown];
        
        //
        UILabel *oneL = [[UILabel alloc] initWithFrame:CGRectMake(5, label.frame.size.height, 120, 30)];
        oneL.text = @"1次";
        oneL.textColor = [UIColor whiteColor];
        
        UILabel *twoL = [[UILabel alloc] initWithFrame:CGRectMake(5, oneL.frame.size.height + oneL.frame.origin.y +5, 120, 30)];
        twoL.text = @"2次";
        twoL.textColor = [UIColor whiteColor];
        
        UILabel *threeL = [[UILabel alloc] initWithFrame:CGRectMake(5, twoL.frame.size.height + twoL.frame.origin.y +5, 120, 30)];
        threeL.text = @"3次";
        threeL.textColor = [UIColor whiteColor];
        
        [actionNumberView addSubview:oneL];
        [actionNumberView addSubview:twoL];
        [actionNumberView addSubview:threeL];
        
        NSString *actionNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionNumber"];//获取
        
        //第一个按钮
        UISwitch *oneSwitchView = [[UISwitch alloc] initWithFrame:CGRectMake(135, oneL.frame.origin.y, 50, 30)];
        self.oneSwitchView2 = oneSwitchView;
        if ([actionNumber  isEqual: @"1"])
        {
            oneSwitchView.on = YES;
        }else
        {
            oneSwitchView.on = NO;
        }
        [oneSwitchView addTarget:self action:@selector(switchOne2) forControlEvents:UIControlEventValueChanged];
        
        //第二个按钮
        UISwitch *twoSwitchView = [[UISwitch alloc] initWithFrame:CGRectMake(135, twoL.frame.origin.y, 50, 30)];
        self.twoSwitchView2 = twoSwitchView;
        if ([actionNumber  isEqual: @"2"])
        {
            twoSwitchView.on = YES;
        }else
        {
            twoSwitchView.on = NO;
        }
        [twoSwitchView addTarget:self action:@selector(switchTwo2) forControlEvents:UIControlEventValueChanged];
        
        //第二个按钮
        UISwitch *threeSwitchView = [[UISwitch alloc] initWithFrame:CGRectMake(135, threeL.frame.origin.y, 50, 30)];
        self.threeSwitchView2 = threeSwitchView;
        if ([actionNumber  isEqual: @"3"]||[actionNumber  isEqual: @""]||actionNumber == nil)
        {
            threeSwitchView.on = YES;
        }else
        {
            threeSwitchView.on = NO;
        }
        [threeSwitchView addTarget:self action:@selector(switchThree2) forControlEvents:UIControlEventValueChanged];
        
        [actionNumberView addSubview:oneSwitchView];
        [actionNumberView addSubview:twoSwitchView];
        [actionNumberView addSubview:threeSwitchView];
        
        
        
        trueBtn.backgroundColor = [UIColor whiteColor];
        
        self.actionNumberView.layer.cornerRadius = 5;
        self.actionNumberView.layer.masksToBounds = YES;
        
        trueBtn.layer.cornerRadius = 5;
        trueBtn.layer.masksToBounds = YES;
        
        [self.actionNumberView addSubview:trueBtn];
        
        [self.view addSubview:self.actionNumberView];
        
    }
    //重新设定位置
    
    self.actionNumberView.frame = CGRectMake(-200, -300, 200, 170);
    
    self.tableView.scrollEnabled = NO;
    
    for (UITableViewCell *cell in self.cellArray)
    {
        cell.userInteractionEnabled = NO;
    }
    
    self.actionNumberView.transform = CGAffineTransformRotate(self.actionNumberView.transform, M_PI);
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.actionNumberView.transform = CGAffineTransformRotate(self.actionNumberView.transform, M_PI);
        
        self.actionNumberView.frame = CGRectMake(self.view.frame.size.width/2-100, 100, 200, 170);
        
    } completion:^(BOOL finished)
     {
         self.actionNumberView.transform = CGAffineTransformIdentity;
         
         self.actionNumberView.userInteractionEnabled = YES;
         self.tableView.scrollEnabled = YES;
     }];
}

//***改 增 点击执行次数窗口的确定按钮
-(void)closeActionNumberView
{
    self.actionNumberView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.actionNumberView.transform = CGAffineTransformRotate(self.actionNumberView.transform, M_PI);
        
        self.actionNumberView.frame = CGRectMake(self.tableView.frame.size.width, -300, 200, 170);
        
    } completion:^(BOOL finished)
     {
         self.actionNumberView.transform = CGAffineTransformIdentity;
         
         for (UITableViewCell *cell in self.cellArray)
         {
             cell.userInteractionEnabled = YES;
         }
         
     }];
}

//***改 增
-(void)switchOne2
{
    
    self.twoSwitchView2.on = NO;
    self.threeSwitchView2.on = NO;
    self.oneSwitchView2.on = YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"actionNumber"];//设定
    self.actionNumbersCell.detailTextLabel.text = [NSString stringWithFormat:@"目前：1 次"];
}

//***改 增
-(void)switchTwo2
{
    self.oneSwitchView2.on = NO;
    self.threeSwitchView2.on = NO;
    self.twoSwitchView2.on = YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"actionNumber"];//设定
    self.actionNumbersCell.detailTextLabel.text = [NSString stringWithFormat:@"目前：2 次"];
}

//***改 增
-(void)switchThree2
{
    
    self.oneSwitchView2.on = NO;
    self.twoSwitchView2.on = NO;
    self.threeSwitchView2.on = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"actionNumber"];//设定
    self.actionNumbersCell.detailTextLabel.text = [NSString stringWithFormat:@"目前：3 次"];
}


//弹窗设置url
-(void)settingProjectUrl
{
    //弹窗
    if (self.downView == nil) {
        UIView *downView = [[UIView alloc] init];
        
        self.downView = downView;
        
        self.downView.backgroundColor = [UIColor blackColor];
        
        
        //标题
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 40)];
        
        label.text = @"服务器URL";
        
        label.textAlignment = NSTextAlignmentCenter;//居中显示
        
        label.font = [UIFont systemFontOfSize:18];
        
        label.textColor = [UIColor whiteColor];
        
        label.backgroundColor = self.downView.backgroundColor;
        
        [self.downView addSubview:label];
        
        
        //输入框
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(3, 45 , 200-6, 75)];
        
        textView.scrollEnabled = YES; //可以滑动
        textView.editable = YES;  //是否允许编辑内容
        textView.font = [UIFont systemFontOfSize:15];
        textView.keyboardType = UIKeyboardTypeURL;//键盘类型
        textView.autocapitalizationType = UITextAutocapitalizationTypeNone;//首字母不大写
        textView.text = [[JYAVSessionHolder instance] serviceUrl];
        [self.downView addSubview:textView];
        self.textView = textView;
        self.textView.delegate = self;
        
        //确定取消按钮
        UIButton *falseBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 125, 80, 40)]; //取消
        
        UIButton *trueBtn= [[UIButton alloc] initWithFrame:CGRectMake(110, 125, 80, 40)]; //确定
        
        [falseBtn setTitle:@"取消" forState:UIControlStateNormal];
        falseBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [falseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [falseBtn addTarget:self action:@selector(touchFalseBtn) forControlEvents:UIControlEventTouchDown];
        
        [trueBtn setTitle:@"确定" forState:UIControlStateNormal];
        trueBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [trueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [trueBtn addTarget:self action:@selector(touchTrueBtn) forControlEvents:UIControlEventTouchDown];
        
        falseBtn.backgroundColor = [UIColor whiteColor];
        
        trueBtn.backgroundColor = [UIColor whiteColor];
        
        self.downView.layer.cornerRadius = 5;
        self.downView.layer.masksToBounds = YES;
        
        trueBtn.layer.cornerRadius = 5;
        trueBtn.layer.masksToBounds = YES;
        
        falseBtn.layer.cornerRadius = 5;
        falseBtn.layer.masksToBounds = YES;
        
        [self.downView addSubview:falseBtn];
        [self.downView addSubview:trueBtn];
        
        [self.view addSubview:self.downView];
        
    }
    //重新设定位置
    
    self.downView.frame = CGRectMake(-200, -300, 200, 170);
    
    self.tableView.scrollEnabled = NO;
    
    for (UITableViewCell *cell in self.cellArray)
    {
        cell.userInteractionEnabled = NO;
    }
    
    self.downView.transform = CGAffineTransformRotate(self.downView.transform, M_PI);
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.downView.transform = CGAffineTransformRotate(self.downView.transform, M_PI);
        
        self.downView.frame = CGRectMake(self.view.frame.size.width/2-100, 100, 200, 170);
        
    } completion:^(BOOL finished)
     {
         self.downView.transform = CGAffineTransformIdentity;
         
         self.downView.userInteractionEnabled = YES;
         self.tableView.scrollEnabled = YES;
     }];
}






-(UISwitch*)newSwitch
{
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 10, 50, 30)];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"switchTick"];
    if ([str  isEqual: @"NO"])
    {
        switchView.on = NO;
    }else
    {
        switchView.on = YES;
    }
    [switchView addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
    
    return switchView;
}

-(void)switchAction
{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"switchTick"];
    if ([str  isEqual: @"NO"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"switchTick"];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"switchTick"];
    }
}


    
    
    
-(void)closephotoNumberView
{
    self.phtotNumberView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.phtotNumberView.transform = CGAffineTransformRotate(self.phtotNumberView.transform, M_PI);
        
        self.phtotNumberView.frame = CGRectMake(self.tableView.frame.size.width, -300, 200, 170);
        
    } completion:^(BOOL finished)
     {
         self.phtotNumberView.transform = CGAffineTransformIdentity;
         
         for (UITableViewCell *cell in self.cellArray)
         {
             cell.userInteractionEnabled = YES;
         }
         
     }];
}
    
    
    





-(void)settingPhotoNumbers
{
    [self.view endEditing:YES];
    
    //弹窗
    if (self.phtotNumberView == nil) {
        UIView *phtotNumberView = [[UIView alloc] init];
        
        self.phtotNumberView = phtotNumberView;
        
        self.phtotNumberView.backgroundColor = [UIColor blackColor];
        
        
        //标题
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 40)];
        
        label.text = @"照片数量";
        
        label.textAlignment = NSTextAlignmentCenter;//居中显示
        
        label.font = [UIFont systemFontOfSize:18];
        
        label.textColor = [UIColor whiteColor];
        
        label.backgroundColor = self.phtotNumberView.backgroundColor;
        
        [self.phtotNumberView addSubview:label];
        
        //确定取消按钮
        UIButton *trueBtn= [[UIButton alloc] initWithFrame:CGRectMake((200-80)/2, 145, 80, 20)]; //确定
        
        [trueBtn setTitle:@"确定" forState:UIControlStateNormal];
        trueBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [trueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [trueBtn addTarget:self action:@selector(closephotoNumberView) forControlEvents:UIControlEventTouchDown];
        
        //1张（省流量、速度快）", @"2张（适中）", @"3张（耗流量，速度慢）
        UILabel *oneL = [[UILabel alloc] initWithFrame:CGRectMake(5, label.frame.size.height, 120, 30)];
        oneL.text = @"1张（省流量）";
        oneL.textColor = [UIColor whiteColor];
        
        UILabel *twoL = [[UILabel alloc] initWithFrame:CGRectMake(5, oneL.frame.size.height + oneL.frame.origin.y +5, 120, 30)];
        twoL.text = @"2张（适中）";
        twoL.textColor = [UIColor whiteColor];
        
        UILabel *threeL = [[UILabel alloc] initWithFrame:CGRectMake(5, twoL.frame.size.height + twoL.frame.origin.y +5, 120, 30)];
        threeL.text = @"3张（耗流量）";
        threeL.textColor = [UIColor whiteColor];
        
        [phtotNumberView addSubview:oneL];
        [phtotNumberView addSubview:twoL];
        [phtotNumberView addSubview:threeL];

        
        int photoNum = [[JYAVSessionHolder instance] savePhotoNum];//获取
        
        //第一个按钮
        UISwitch *oneSwitchView = [[UISwitch alloc] initWithFrame:CGRectMake(135, oneL.frame.origin.y, 50, 30)];
        self.oneSwitchView = oneSwitchView;
        if (photoNum == 0)
        {
            oneSwitchView.on = YES;
        }else
        {
            oneSwitchView.on = NO;
        }
        [oneSwitchView addTarget:self action:@selector(switchOne) forControlEvents:UIControlEventValueChanged];
        
        //第二个按钮
        UISwitch *twoSwitchView = [[UISwitch alloc] initWithFrame:CGRectMake(135, twoL.frame.origin.y, 50, 30)];
        self.twoSwitchView = twoSwitchView;
        if (photoNum == 1)
        {
            twoSwitchView.on = YES;
        }else
        {
            twoSwitchView.on = NO;
        }
        [twoSwitchView addTarget:self action:@selector(switchTwo) forControlEvents:UIControlEventValueChanged];
        
        //第二个按钮
        UISwitch *threeSwitchView = [[UISwitch alloc] initWithFrame:CGRectMake(135, threeL.frame.origin.y, 50, 30)];
        self.threeSwitchView = threeSwitchView;
        if (photoNum == 2)
        {
            threeSwitchView.on = YES;
        }else
        {
            threeSwitchView.on = NO;
        }
        [threeSwitchView addTarget:self action:@selector(switchThree) forControlEvents:UIControlEventValueChanged];
        
        [phtotNumberView addSubview:oneSwitchView];
        [phtotNumberView addSubview:twoSwitchView];
        [phtotNumberView addSubview:threeSwitchView];
        
        
        
        trueBtn.backgroundColor = [UIColor whiteColor];
        
        self.phtotNumberView.layer.cornerRadius = 5;
        self.phtotNumberView.layer.masksToBounds = YES;
        
        trueBtn.layer.cornerRadius = 5;
        trueBtn.layer.masksToBounds = YES;
        
        [self.phtotNumberView addSubview:trueBtn];
        
        [self.view addSubview:self.phtotNumberView];
        
    }
    //重新设定位置
    
    self.phtotNumberView.frame = CGRectMake(-200, -300, 200, 170);
    
    self.tableView.scrollEnabled = NO;
    
    for (UITableViewCell *cell in self.cellArray)
    {
        cell.userInteractionEnabled = NO;
    }
    
    self.phtotNumberView.transform = CGAffineTransformRotate(self.phtotNumberView.transform, M_PI);
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.phtotNumberView.transform = CGAffineTransformRotate(self.phtotNumberView.transform, M_PI);
        
        self.phtotNumberView.frame = CGRectMake(self.view.frame.size.width/2-100, 100, 200, 170);
        
    } completion:^(BOOL finished)
     {
         self.phtotNumberView.transform = CGAffineTransformIdentity;
         
         self.phtotNumberView.userInteractionEnabled = YES;
         self.tableView.scrollEnabled = YES;
     }];
}


-(void)switchOne
{

    self.twoSwitchView.on = NO;
    self.threeSwitchView.on = NO;
    self.oneSwitchView.on = YES;

    [[JYAVSessionHolder instance] setSavePhotoNum:(int)0];//设定
}

-(void)switchTwo
{
    self.oneSwitchView.on = NO;
    self.threeSwitchView.on = NO;
    self.twoSwitchView.on = YES;

    [[JYAVSessionHolder instance] setSavePhotoNum:(int)1];
}

-(void)switchThree
{

    self.oneSwitchView.on = NO;
    self.twoSwitchView.on = NO;
    self.threeSwitchView.on = YES;
    [[JYAVSessionHolder instance] setSavePhotoNum:(int)2];
}

@end
