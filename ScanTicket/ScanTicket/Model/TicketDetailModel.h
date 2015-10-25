//
//  TicketDetailModel.h
//  ScanTicket
//
//  Created by 冠东 陈 on 10/6/15.
//  Copyright © 2015 冠东 陈. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketDetailModel : NSObject
//票条码
@property(nonatomic,copy)NSString * barCode;
//检票时间  进场时间
@property(nonatomic,copy)NSString * checkTime;
//该票创建时间
@property(nonatomic,copy)NSString * createTime;
//楼层
@property(nonatomic,copy)NSString * floor;
//ticketID
@property(nonatomic,assign)int ticketID;
//是否检出进场 N  Y
@property(nonatomic,copy)NSString * isCheck;
//场馆code
@property(nonatomic,copy)NSString * placeCode;
//演出场馆名字
@property(nonatomic,copy)NSString * placeName;
@property(nonatomic,copy)NSString * realPrice;
@property(nonatomic,copy)NSString * resultCode;
//排
@property(nonatomic,copy)NSString * row;
//销售组
@property(nonatomic,copy)NSString * saleGroup;
//座位号
@property(nonatomic,copy)NSString * seat;
//演出名字
@property(nonatomic,copy)NSString * showName;
//演出时间
@property(nonatomic,copy)NSString * showTime;

@property(nonatomic,copy)NSString * uuid;
//扫描次数
@property(nonatomic,assign)NSInteger scanNumbers;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
