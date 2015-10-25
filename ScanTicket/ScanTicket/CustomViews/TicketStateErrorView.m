//
//  TicketStateErrorView.m
//  ScanTicket
//
//  Created by 冠东 陈 on 10/6/15.
//  Copyright © 2015 冠东 陈. All rights reserved.
//

#import "TicketStateErrorView.h"

@interface TicketStateErrorView ()

@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)UILabel *stateLable;


@end

@implementation TicketStateErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = IM_GrayBgColor;
        
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"jinggao"];
        
        [self addSubview:_imageView];
        
        _stateLable = [[UILabel alloc]init];
        
        _stateLable.textColor = [UIColor whiteColor];
        
        _stateLable.font = [UIFont systemFontOfSize:15];
        
        _stateLable.textAlignment  = NSTextAlignmentCenter;
        
        [self addSubview:_stateLable];
    }
    return self;
}

-(void)setStateStr:(NSString *)stateStr{
    
    if (stateStr) {
        _stateStr = stateStr;
        
        _stateLable.text = stateStr;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _imageView.frame = CGRectMake(0, 0, 100, 100);
    _imageView.center = self.center;
    
    _stateLable.frame = CGRectMake(0, 0, 300, 30);
    
    _stateLable.center = CGPointMake(self.center.x, self.center.y+80);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
