//
//  HistoryModel.h
//  ScanTicket
//
//  Created by 冠东 陈 on 10/7/15.
//  Copyright © 2015 冠东 陈. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryModel : NSObject
@property(nonatomic,assign)int historyID;
@property(nonatomic,copy)NSString * scanTime;
@property(nonatomic,copy)NSString * source;
@property(nonatomic,assign)int  ticketId;
@property(nonatomic,copy)NSString * uuid;

- (instancetype)initWithDic:(NSDictionary*)dic;
@end
