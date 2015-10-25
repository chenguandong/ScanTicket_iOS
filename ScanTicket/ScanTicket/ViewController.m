//
//  ViewController.m
//  ScanTicket
//
//  Created by 冠东 陈 on 10/6/15.
//  Copyright © 2015 冠东 陈. All rights reserved.
//

#import "ViewController.h"
#import "NetWorkTools.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [NetWorkTools checkNetworking:^(BOOL isNetwork) {
        
        [self performSegueWithIdentifier:@"Welcome" sender:self];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
