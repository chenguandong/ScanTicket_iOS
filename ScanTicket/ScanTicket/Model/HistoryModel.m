//
//  HistoryModel.m
//  ScanTicket
//
//  Created by 冠东 陈 on 10/7/15.
//  Copyright © 2015 冠东 陈. All rights reserved.
//

#import "HistoryModel.h"

@implementation HistoryModel


- (instancetype)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        
        _historyID = [dic[@"id"] intValue];
        _scanTime = dic[@"scanTime"];
        _source = dic[@"source"];
        _ticketId = [dic[@"ticketId"] intValue];
        _uuid = dic[@"uuid"];
        
    }
    return self;
}

@end
