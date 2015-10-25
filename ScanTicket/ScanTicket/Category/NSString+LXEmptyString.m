//
//  NSString+LXEmptyString.m
//  GoodLuck
//
//  Created by 冠东 陈 on 15/9/8.
//  Copyright (c) 2015年 郑州立信科技. All rights reserved.
//

#import "NSString+LXEmptyString.h"

@implementation NSString (LXEmptyString)

+(NSString*)isEmptyString:(NSString*)str{

    if (str) {
        return str;
    }else{
    
        return @"";
    }
}

+(NSString*)getFormatDateTime:(NSString*)timeStr{
    
    
    NSString *year = [timeStr substringWithRange:NSMakeRange(0, 4)];
    
    NSString *mounth =[timeStr substringWithRange:[timeStr rangeOfComposedCharacterSequencesForRange:NSMakeRange(4, 2)]];
    NSString *day =[timeStr substringWithRange:NSMakeRange(6, 2)];
    NSString *hour =[timeStr substringWithRange:NSMakeRange(8, 2)];
    NSString *fen =[timeStr substringWithRange:NSMakeRange(10, 2)];
    
    return [NSString stringWithFormat:@"%@年%@月%@日 %@: %@",year,mounth,day,hour,fen];
    
}

@end
