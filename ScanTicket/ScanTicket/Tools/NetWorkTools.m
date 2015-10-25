//
//  NetWorkTools.m
//  iOSStudy
//
//  Created by chenguandong on 15/1/31.
//  Copyright (c) 2015年 chenguandong. All rights reserved.
//

#import "NetWorkTools.h"
#import "JsonTools.h"
#import <SVProgressHUD.h>
@implementation NetWorkTools


+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}





+(void)postHttpWithHttpAdress:(NSString*)httpAdress parameters:(id)parameters success:(success)success error:(error)error isNetworking:(isNetwork)isNetworking {
    

    if (SharedApp.isNetworking) {
        //  准备请求
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];//@"text/plain",

        //NSDictionary *dic = @{@"json":[JsonTools jsonDicToString:parameters]};
        
        [manager GET:httpAdress parameters:parameters success:success failure:error];
    }else{
        
        isNetworking(false);
        
        NSLog(@"REACHABLE!");
      
        
        [MBProgressHUD showHUDWithTextAutoHidden:@"无网络连接"];
        

    }

}


/*


+(void)postHttpForImageUpload :(id)parameters success:(success)success error:(error)error isNetworking:(isNetwork)isNetworking {
    
    
    if (SharedApp.isNetworking) {
        //  准备请求
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];//@"text/plain",

        NSDictionary *dic = @{@"json":[JsonTools jsonDicToString:parameters]};
        
        [manager POST:kBaseUrl parameters:dic success:success failure:error];
    }else{
        
        isNetworking(false);
        
        NSLog(@"REACHABLE!");
        [SVProgressHUD showErrorWithStatus:@"无网络连接" maskType:SVProgressHUDMaskTypeGradient];
        
        double delayInSeconds = 3.0; dispatch_time_t
        popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // code to be executed on the main queue after delay
            [SVProgressHUD dismiss];
        });
        
        
    }
}




+(void)postHttpForFileUpload :(id)parameters success:(success)success error:(error)error isNetworking:(isNetwork)isNetworking {
    
    
    
    

    
    if (SharedApp.isNetworking) {
        //  准备请求

        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *voicePath = [NSString stringWithFormat:@"%@selfRecord.wav", NSTemporaryDirectory()];
        
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        
        [manager POST:@"http://116.255.239.201:8080/mschool/service.action?" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:voicePath isDirectory:NO]
                                       name:@"file"//talkMessage@"amr"
                                   fileName:@"selfRecord.wav"
                                   mimeType:@"audio/mpeg"
                                      error:nil];
            
        } success:success failure:error];
       //  [manager GET:kBaseUrl parameters:dic success:success failure:error];
        
    }else{
        
        isNetworking(false);
        
        NSLog(@"REACHABLE!");
        [SVProgressHUD showErrorWithStatus:@"无网络连接" maskType:SVProgressHUDMaskTypeGradient];
        
        double delayInSeconds = 3.0; dispatch_time_t
        popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // code to be executed on the main queue after delay
            [SVProgressHUD dismiss];
        });
        
        
    }
     
    
}
 
 */

/**
 * 检查网络连接
 */
+(void)checkNetworking:(isNetwork)isNetwork{
    

    NSURL *baseURL = [NSURL URLWithString:@"http://www.baidu.com/"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                SharedApp.isNetworking = YES;
                
                isNetwork(YES);
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
                SharedApp.isNetworking = NO;
                
                isNetwork(NO);
                
            default:
                [operationQueue setSuspended:YES];
                
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
}




@end
