//
//  TicketDetailModel.m
//  ScanTicket
//
//  Created by 冠东 陈 on 10/6/15.
//  Copyright © 2015 冠东 陈. All rights reserved.
//

#import "TicketDetailModel.h"

@implementation TicketDetailModel
- (instancetype)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        _uuid = dic[@"uuid"];
        _showName  = dic[@"showName"];
        _placeName  = dic[@"placeName"];
        _showTime = dic[@"showTime"];
        _floor = dic[@"floor"];
        _row = dic[@"row"];
        _seat = dic[@"seat"];
        _realPrice = dic[@"realPrice"];
        _saleGroup = dic[@"saleGroup"];
        _createTime = dic[@"createTime"];
        _barCode = dic[@"barCode"];
        _placeCode = dic[@"placeCode"];
        _isCheck= dic[@"isCheck"];
        _checkTime = dic[@"checkTime"];
        _ticketID = [dic[@"id"]intValue];
        _scanNumbers = [dic[@"scanNumbers"]integerValue];
    }
    return self;
}
@end
