//
//  QRCodeReaderVC.m
//  ScanTicket
//
//  Created by 冠东 陈 on 10/7/15.
//  Copyright © 2015 冠东 陈. All rights reserved.
//

#import "QRCodeReaderVC.h"
#import "TTMQRCodeReader.h"
#import <AVFoundation/AVMetadataObject.h>
#import "TicketDetailVC.h"
#import <AVFoundation/AVFoundation.h>
@interface QRCodeReaderVC ()<TTMQRCodeReaderDelegate>
//扫描的二维码
@property(nonatomic,copy)NSString *ticketCode;

@property(nonatomic,strong)TicketDetailVC *detailVC;

@property(nonatomic,assign)BOOL isFlashLight;

@property(nonatomic,strong)AVAudioPlayer* player;
@end

@implementation QRCodeReaderVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[TTMQRCodeReader sharedReader] setDelegate:self];
    
    [[TTMQRCodeReader sharedReader] startReaderOnView:self.view withFlashLight:_isFlashLight];
    self.title = @"识票";
    
    
   
    
   
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    
    [[TTMQRCodeReader sharedReader] stopReader];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    self.title = @"";
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
   
    
}

- (void)flashLight:(BOOL)flashLight{
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    if ([captureDevice hasTorch])
    {
        BOOL locked = [captureDevice lockForConfiguration:&error];
        if (locked)
        {
            if (flashLight)
            {
                [captureDevice setTorchMode:AVCaptureTorchModeOn];
                _isFlashLight = YES;
            } else {
                [captureDevice setTorchMode:AVCaptureTorchModeOff];
                _isFlashLight = NO;
            }
            [captureDevice unlockForConfiguration];
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
    
        self.navigationItem.rightBarButtonItem = backBarButton;
    
    
    
    
  
   
}

- (void)rightBarButtonClick:(id)sender{
    
    UIBarButtonItem *barButton = (UIBarButtonItem *)sender;
    
    _isFlashLight = !_isFlashLight;
    
    if (_isFlashLight) {
        
        barButton.image = [UIImage imageNamed:@"open"];
        
    }else{
        
        barButton.image = [UIImage imageNamed:@"close"];
    
    }

    
    [[TTMQRCodeReader sharedReader] stopReader];
    
    [[TTMQRCodeReader sharedReader] setDelegate:self];
    
    [[TTMQRCodeReader sharedReader] startReaderOnView:self.view withFlashLight:_isFlashLight];
}


#pragma mark - TTMQRCodeReaderDelegate

- (void)didDetectQRCode:(AVMetadataMachineReadableCodeObject *)qrCode {
    //qrCode.stringValue
    
    _ticketCode =qrCode.stringValue;
    
    [self performSegueWithIdentifier:@"QR" sender:self];
    
    [self playSuccessVoice]
    ;
   
}

- (void)playSuccessVoice{
    //扬声器播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSError* err;
    
    if (!_player) {
        _player = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:
                   [[NSBundle mainBundle] URLForResource:@"qrcode_completed" withExtension:@"mp3"]
                   error:&err ];
    }
    
    
    _player.volume = 1;
    if (err) {
        NSLog(@"play error");
    }else{
        NSLog(@"play success");
    }
    [_player prepareToPlay];
    
    [_player play];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"QR"]) {
        
        _detailVC  = [segue destinationViewController];
        
        _detailVC.ticketQRCode  = _ticketCode;
    }
    
    
}


@end
