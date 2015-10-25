//
//  TicketHistoryVC.m
//  ScanTicket
//
//  Created by 冠东 陈 on 10/7/15.
//  Copyright © 2015 冠东 陈. All rights reserved.
//

#import "TicketHistoryVC.h"
#import "HistoryModel.h"
@interface TicketHistoryVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation TicketHistoryVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArr = [[NSMutableArray alloc]init];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource =self;
    
    [self getHttpDataWithTicketID:_ticketID];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    self.tableView.rowHeight = 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"historyCell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    HistoryModel *model = _dataArr[indexPath.row];
    
    if (model) {
        
        cell.textLabel.text = [NSString getFormatDateTime:model.scanTime];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@客户端",model.source];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        
    }
    
    
    return cell;
}


-(void)getHttpDataWithTicketID:(NSString*)ticketID{
    
    //http://www.shipiao.net/api/queryTicketList.json?ticketId=1
    MBProgressHUD *hud = [MBProgressHUD createHUD];
    
    NSDictionary *parms = @{
                            @"ticketId":ticketID,
                            };
    
    [NetWorkTools postHttpWithHttpAdress:@"http://www.shipiao.net/api/queryTicketList.json?" parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        IM_LogResponseString;
        
        if ([operation responseString]) {
            NSDictionary *dic = [JsonTools getJsonNSDictionary:[operation responseString]];
            
            
            if ([dic[@"success"] boolValue]||[dic[@"code"] isEqualToString:@"100"]) {
                
                for (NSDictionary *hisDic in dic[@"result"]) {
                    
                    HistoryModel *model = [[HistoryModel alloc]initWithDic:hisDic];
                    
                    [_dataArr addObject:model];
                    
                }
                
                [self.tableView reloadData];
            }
        }
        
        [hud hide:YES];
        
    } error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [hud hide:YES];
        
        [MBProgressHUD showHUDWithTextAutoHidden:@"请求服务器失败"];
        
        
    } isNetworking:^(BOOL isNetwork) {
        
        [hud hide:YES];
        
        [MBProgressHUD showHUDWithTextAutoHidden:@"请检查网络连接"];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
