//
//  TicketDetailVC.m
//  ScanTicket
//
//  Created by 冠东 陈 on 10/6/15.
//  Copyright © 2015 冠东 陈. All rights reserved.
//

#import "TicketDetailVC.h"
#import "TicketDetailModel.h"
#import "NSString+LXEmptyString.h"
#import "TicketStateErrorView.h"
#import "TicketHistoryVC.h"
@interface TicketDetailVC ()
//票务名称
@property (weak, nonatomic) IBOutlet UILabel *ticketName;
//场馆
@property (weak, nonatomic) IBOutlet UILabel *adressName;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
//座位
@property (weak, nonatomic) IBOutlet UILabel *seatLable;
//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLable;

@property (weak, nonatomic) IBOutlet UIButton *ticketStateButton;

@property(nonatomic,strong)TicketDetailModel *ticketModel;

@property (weak, nonatomic) IBOutlet UIImageView *ticketStateImageView;

@property(nonatomic,strong)TicketStateErrorView *errorView;
@end

@implementation TicketDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self getHttpDataWithQRCode:_ticketQRCode];
    

    
}

- (void)backButtonClick{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)continueQR:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)updateUI:(TicketDetailModel*)model{
    
    _ticketName.text = [NSString isEmptyString:model.showName];
    _adressName.text = [NSString stringWithFormat:@"场馆: %@",[NSString isEmptyString:model.placeName]];
    if ([NSString isEmptyString:model.showTime].length>5) {
        _timeLable.text =[NSString stringWithFormat:@"时间: %@",[NSString getFormatDateTime:model.showTime]];
    }else{
        _timeLable.text = [NSString stringWithFormat:@"时间: %@",[NSString isEmptyString:model.showTime]];
    }
    _seatLable.text = [NSString stringWithFormat:@"座位: %@ %@ 排 %@ 号",model.floor,model.row,model.seat];
    
    _priceLable.text = [NSString stringWithFormat:@"票价: %@",[NSString isEmptyString:model.realPrice]];
    
    if ([model.isCheck isEqualToString:@"Y"]) { //已经检出
        _ticketStateImageView.hidden = NO;
        _ticketStateButton.enabled = false;
        [_ticketStateButton setTitle:[NSString stringWithFormat:@"该票已检,检票时间为 %@",[NSString getFormatDateTime:[NSString isEmptyString:model.checkTime]]] forState:UIControlStateNormal];
    }else{
        _ticketStateImageView.hidden = YES;
        _ticketStateButton.enabled = true;
        
        [_ticketStateButton setTitle:[NSString stringWithFormat:@"该票已被扫描%ld次 (点击查看详情)",model.scanNumbers] forState:UIControlStateNormal];
    }
}

-(void)getHttpDataWithQRCode:(NSString*)ticketQRCode{
    
    //http://www.shipiao.net/api/queryTicket.json?barCode=XNJE519573PKLW870LTN&source=Android
    MBProgressHUD *hud = [MBProgressHUD createHUD];
    
    NSDictionary *parms = @{
                            @"barCode":ticketQRCode,
                            @"source":@"iOS"
                            };
    
    [NetWorkTools postHttpWithHttpAdress:@"http://www.shipiao.net/api/queryTicket.json?" parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        IM_LogResponseString;
        
        if ([operation responseString]) {
            NSDictionary *dic = [JsonTools getJsonNSDictionary:[operation responseString]];
            
            

                
                //成功
                if ([dic[@"code"] isEqualToString:@"100"]) {
                
                    _ticketModel = [[TicketDetailModel alloc]initWithDic:dic[@"result"]];
                    
                    [self updateUI:_ticketModel];

               
                }else{
                                  [self addErrorView:@"当前二维码无法验证,请谨慎!"];
                }
                
//                 //此条形码无效
//                else if([dic[@"code"] isEqualToString:@"102"]){
//                
//                    [self addErrorView:@"当前二维码无法验证,请谨慎!"];
//                    
//                //无此剧场
//                }else{
//                 [self addErrorView:@"无此剧场!"];
//                }
//                
            }

        
        [hud hide:YES];
        
    } error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [hud hide:YES];
        
        NSLog(@"%@",[error userInfo]);
        
        [MBProgressHUD showHUDWithTextAutoHidden:@"请求服务器失败"];
        
           [self addErrorView:@"当前二维码无法验证,请谨慎!"];
        
        
    } isNetworking:^(BOOL isNetwork) {
        
        [hud hide:YES];
        
        [MBProgressHUD showHUDWithTextAutoHidden:@"请检查网络连接"];
        [self addErrorView:@"当前二维码无法验证,请谨慎!"];
    }];
    
}

- (void)addErrorView:(NSString*)stateText{
    
    if (!_errorView) {
        [_errorView removeFromSuperview];
        _errorView = nil;
    }
    
    _errorView = [[TicketStateErrorView alloc]initWithFrame:CGRectMake(0, 0, IM_SCREEN_WIDTH, IM_SCREEN_HEIGHT)];
    
    _errorView.stateStr = stateText;
    [self.view addSubview:_errorView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.title = @"门票信息";
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    self.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
   TicketHistoryVC *hisVC =  [segue destinationViewController];
    hisVC.ticketID = [NSString stringWithFormat:@"%d",_ticketModel.ticketID];
}


@end
