//
//  TicketHistoryVC.h
//  ScanTicket
//
//  Created by 冠东 陈 on 10/7/15.
//  Copyright © 2015 冠东 陈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketHistoryVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,copy)NSString *ticketID;
@end
