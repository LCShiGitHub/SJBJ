//
//  ViewController.m
//  scollview animation
//
//  Created by kkqb on 16/9/1.
//  Copyright © 2016年 chinapeihu. All rights reserved.
//

#import "ViewController.h"

#import "JT3DScrollView.h"

@interface ViewController ()<UIScrollViewDelegate>{
    
    __weak IBOutlet UISegmentedControl *segmented;
    
    __weak IBOutlet UIButton *nextBtn;
    
    __weak IBOutlet UIButton *backBtn;
    
    JT3DScrollView *scrollView;
    
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
}

- (void) setUI{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 120;
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height - 260;
    
    scrollView = [[JT3DScrollView alloc] initWithFrame:CGRectMake(60, 130, width, height)];
    scrollView.backgroundColor = [UIColor clearColor];
    
    scrollView.contentSize = CGSizeMake(width * 30, height);
    
    scrollView.pagingEnabled=YES;
    scrollView.effect = JT3DScrollViewEffectDepth;
    scrollView.delegate = self;
    
    [self.view addSubview:scrollView];
    
    for (NSInteger i = 0 ; i < 30; i ++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"0%02ld.jpg",i+1]];
//        NSLog(@"name:%@",[NSString stringWithFormat:@"0%02ld.jpg",i]);
        
        imgView.layer.cornerRadius = 6.0;
        imgView.layer.masksToBounds = YES;
        
        [scrollView addSubview:imgView];
    }
    
    nextBtn.backgroundColor = [UIColor colorWithRed:33/255. green:158/255. blue:238/255. alpha:1.];
    nextBtn.layer.cornerRadius = 5.;
    
    backBtn.backgroundColor = [UIColor colorWithRed:33/255. green:158/255. blue:238/255. alpha:1.];
    backBtn.layer.cornerRadius = 5.;
    
    segmented.selectedSegmentIndex = 2;
    
}


- (IBAction)segmented:(UISegmentedControl *)sender {
    JT3DScrollViewEffect effect;
    switch (sender.selectedSegmentIndex) {
        case 0:
            effect = JT3DScrollViewEffectCards;
            break;
        case 1:
            effect = JT3DScrollViewEffectCarousel;
            break;
        case 2:
            effect = JT3DScrollViewEffectDepth;
            break;
        case 3:
            effect = JT3DScrollViewEffectTranslation;
            break;
            
        default:
            break;
    }
    scrollView.effect = effect;
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    [scrollView loadNextPage:YES];
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [scrollView loadPreviousPage:YES];
}




@end
