//
//  NetConnect.m
//  InvestLive
//
//  Created by sands on 2017/2/13.
//  Copyright © 2017年 sandsyu. All rights reserved.
//
//  网络请求管理类
#import "NetConnect.h"

static NetConnect *instance = nil;

@implementation NetConnect

#define BaseURL @""

- (instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"init");
        self.dispathList = [[NSMutableDictionary alloc]initWithCapacity:0];
        self.manager = [self GetAFHTTPSessionManagerObject];
    }
    return self;
}


+ (NetConnect *)getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetConnect alloc] init];
    });
    return instance;
    
}

-(AFHTTPSessionManager*)GetAFHTTPSessionManagerObject{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return session;
}


- (void)AFNetGet:(NSString *)method params:(NSDictionary *)params result:(NetConnectResultResultBlock)result{
    
    NSString* url = [NSString stringWithFormat:@"%@%@",BaseURL,method];
    
    NSURLSessionDataTask* task = [self.manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.dispathList removeObjectForKey:method];
        result(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.dispathList removeObjectForKey:method];
    }];
    
    //持有一个当前存在的请求列表
    [self.dispathList setObject:task forKey:method];
}

- (void)AFNetPOST:(NSString *)method params:(NSDictionary *)params result:(NetConnectResultResultBlock)result {
    
    NSString* url = [NSString stringWithFormat:@"%@%@",BaseURL,method];
    
    NSURLSessionDataTask* task =  [self.manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.dispathList removeObjectForKey:method];
        result(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.dispathList removeObjectForKey:method];
    }];
    
    [self.dispathList setObject:task forKey:method];
}


- (void)cancleAllTask {
    [self.manager.operationQueue cancelAllOperations];
}

- (void)cancelTaskWithMethon:(NSString*)Methon{
    NSURLSessionDataTask* task = self.dispathList[Methon];
    if (task) {
        [task cancel];
    }
}

@end
