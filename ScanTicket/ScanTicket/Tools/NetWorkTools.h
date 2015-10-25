//
//  NetWorkTools.h
//  iOSStudy
//
//  Created by chenguandong on 15/1/31.
//  Copyright (c) 2015年 chenguandong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>



typedef void(^isNetwork) (BOOL isNetwork);

typedef void(^success)(AFHTTPRequestOperation *operation, id responseObject) ;
typedef void(^error)(AFHTTPRequestOperation *operation, NSError *error);
typedef void(^isNetwork) (BOOL isNetwork);

@interface NetWorkTools : NSObject



+ (instancetype)sharedInstance;



/**
 *  发送Http请求
 *  @param httpAdress   请求地址
 *  @param parameters   参数
 *  @param success      成功回调
 *  @param error        失败回调
 *  @param isNetworking 网络回调
 */
+(void)postHttpWithHttpAdress:(NSString*)httpAdress parameters:(id)parameters success:(success)success error:(error)error isNetworking:(isNetwork)isNetworking;



/*
 *检查网络连接注册通知
 */
+(void)checkNetworking:(isNetwork)isNetwork;




    
@end
