//
//  ContinuingNetworking.m
//  JYVivoUI2
//
//  Created by junyufr on 2016/12/7.
//  Copyright © 2016年 timedge. All rights reserved.
//

#import "ContinuingNetworking.h"
#import "HttpService.h"
#import "JYAVSessionHolder.h"


@interface ContinuingNetworking ()

@property (retain, nonatomic) dispatch_queue_t queue;

@property (nonatomic, assign) bool success;

@property (nonatomic, assign) bool stop;

@property (nonatomic, assign) bool networking;

@property (nonatomic, strong) NSTimer *timer;


@end

@implementation ContinuingNetworking

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static ContinuingNetworking *netWork;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if(netWork == nil)
        {
            
            netWork = [super allocWithZone:zone];
            
        }
    });
    return netWork;
    
}

-(void)stopNetworking
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)startNetworking
{
    if (!self.timer) {
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(network) userInfo:nil repeats:YES];
    }
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}


-(void)network
{
    if (!_networking) {
        
        _networking = YES;
        
        NSURL *url = [NSURL URLWithString:@"https://122.112.217.80:9444/AuthAppServerProject/input"];
        
        [self postSync:url body:[self postBody] success:^(NSInteger statusCode, NSData *body) {
            
            NSLog(@"body = %@",body);
            
            _networking = NO;
            
        } fail:^(NSError *error) {
            
            NSLog(@"%@",error);
            
            _networking = NO;
        }];
    }
}


-(NSData *) postBody
{
    NSMutableData *data = [[NSMutableData alloc] init];
    
    [data appendData:[@"a"  dataUsingEncoding:NSUTF8StringEncoding]];
    
    return data;
}


-(void)postSync:(NSURL*)serviceUrl body:(NSData*)body success:(httpServiceDoneBlock)doneBlock fail:(httpServiceErrorBlock)errorBlock
{
    @try {
        //抛出
        int count = 0;
        NSError *error = nil;
        while (++count <= 1)
        {
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serviceUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:2];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:body];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField:@"Content-Length"];
            NSURLResponse *respose = nil;
            NSData* received = [NSURLConnection sendSynchronousRequest:request returningResponse:&respose error:&error];
            if (!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    doneBlock([(NSHTTPURLResponse*)respose statusCode]  ,received);
                    
                });
                return;
            }
        }
        if (errorBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
        }
    }
    @catch (NSException *exception)
    {
        if (errorBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithDomain:@"continuingService" code:0 userInfo:@{@"exception":exception}];
                errorBlock(error);
            });
        }
    }
    @finally {
    }
}


-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _queue = dispatch_queue_create("continuingService", NULL);
    }
    return self;
}




@end
