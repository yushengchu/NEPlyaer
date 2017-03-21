//
//  NetConnect.h
//  InvestLive
//
//  Created by sands on 2017/2/13.
//  Copyright © 2017年 sandsyu. All rights reserved.
//
//  网络请求管理类
#import <Foundation/Foundation.h>
#import "AFNetworking.h"


typedef void(^NetConnectResultResultBlock)(bool status, id result);

@interface NetConnect : NSObject

@property (nonatomic, strong) NSMutableDictionary* dispathList;
@property (nonatomic, strong) AFHTTPSessionManager* manager;


+ (NetConnect *)getInstance;

/**
 *  NetConnect GET
 *
 *  @param method 方法名
 *  @param params 请求参数
 *  @param result 返回数据
 */
- (void)AFNetGet:(NSString *)method params:(NSDictionary *)params result:(NetConnectResultResultBlock)result;


/**
 *  NetConnect POST
 *
 *  @param method 方法名
 *  @param params 请求参数
 *  @param result 返回数据
 */
- (void)AFNetPOST:(NSString *)method params:(NSDictionary*)params result:(NetConnectResultResultBlock)result;

/**
 *  取消所有请求
 */
- (void)cancleAllTask;


/**
 *  取消指定方法的请求
 */
- (void)cancelTaskWithMethon:(NSString*)Methon;



@end
