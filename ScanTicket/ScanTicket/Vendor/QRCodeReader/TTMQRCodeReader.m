//
//  TTMQRCodeReader.m
//  iOS7Sampler
//
//  Created by Shuichi Tsutsumi on 2015/04/08.
//  Copyright (c) 2015年 Shuichi Tsutsumi. All rights reserved.
//

#import "TTMQRCodeReader.h"
@import AVFoundation;
//设备宽/高/坐标
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define KDeviceFrame [UIScreen mainScreen].bounds

static const float kLineMinY = 185;
static const float kLineMaxY = 385;
static const float kReaderViewWidth = 200;
static const float kReaderViewHeight = 200;

@interface TTMQRCodeReader ()
<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureMetadataOutput *captureMetadataOutput;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) UIImageView *line;//交互线
@property (nonatomic, strong) NSTimer *lineTimer;//交互线控制
@end


@implementation TTMQRCodeReader{
    AVCaptureDevice *captureDevice;
}

+ (instancetype)sharedReader {
    
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


// =============================================================================
#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)       captureOutput:(AVCaptureOutput *)captureOutput
    didOutputMetadataObjects:(NSArray *)metadataObjects
              fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *metadataObject in metadataObjects) {
        
        if (![metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            continue;
        }
        
        AVMetadataMachineReadableCodeObject *machineReadableCode = (AVMetadataMachineReadableCodeObject *)metadataObject;
        if ([self.delegate respondsToSelector:@selector(didDetectQRCode:)]) {
            [self.delegate didDetectQRCode:machineReadableCode];
            [self stopReader];
        }
    }
}


// =============================================================================
#pragma mark - Private


// =============================================================================
#pragma mark - Public

- (void)startReaderOnView:(UIView *)view withFlashLight:(BOOL)flashLightOn{
    
    view.backgroundColor = [UIColor whiteColor];
 
    
    // Find rear camera
    NSError *error;
    
    for (AVCaptureDevice *aCaptureDevice in [AVCaptureDevice devices]) {
        if (aCaptureDevice.position == AVCaptureDevicePositionBack) {
            captureDevice = aCaptureDevice;
        }
    }
    if (!captureDevice) {
        NSLog(@"Couldn't find rear camera.");
        return;
    }
    
    
    
    
    
    
    
    // Create AVCaptureDeviceInput object
    AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"error:%@", error);
        return;
    }
    
    // Create capture session and add an input to the session
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    if ([self.captureSession canAddInput:captureDeviceInput]) {
        [self.captureSession addInput:captureDeviceInput];
    }
    
    // Create capture metadata output and add to the session
    self.captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    if ([self.captureSession canAddOutput:self.captureMetadataOutput]) {
        [self.captureSession addOutput:self.captureMetadataOutput];
    }
    
    // Set target metadata object types
    self.captureMetadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    
    //设置扫面区域
    //[self.captureMetadataOutput setRectOfInterest:[self getReaderViewBoundsWithSize:CGSizeMake(kReaderViewWidth, kReaderViewHeight)]];
    
    // Setup preview layer
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;// AVLayerVideoGravityResizeAspect is default.
    captureVideoPreviewLayer.frame = view.bounds;
    
    [view.layer addSublayer:captureVideoPreviewLayer];
    
     [self setOverlayPickerView:view];
    
    [self.captureSession startRunning];
    
    
    if (_lineTimer)
    {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
    
    _lineTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 20 target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
    
    if ([captureDevice hasTorch])
    {
        BOOL locked = [captureDevice lockForConfiguration:&error];
        if (locked)
        {
            
            if (flashLightOn) {
                [captureDevice setTorchMode:AVCaptureTorchModeOn];
                [captureDevice unlockForConfiguration];
            }
        }
    }
}

#pragma mark 上下滚动交互线

- (void)animationLine
{
    __block CGRect frame = _line.frame;
    
    static BOOL flag = YES;
    
    if (flag)
    {
        frame.origin.y = kLineMinY;
        flag = NO;
        
        [UIView animateWithDuration:1.0 / 20 animations:^{
            
            frame.origin.y += 5;
            _line.frame = frame;
            
        } completion:nil];
    }
    else
    {
        if (_line.frame.origin.y >= kLineMinY)
        {
            if (_line.frame.origin.y >= kLineMaxY - 12)
            {
                frame.origin.y = kLineMinY;
                _line.frame = frame;
                
                flag = YES;
            }
            else
            {
                [UIView animateWithDuration:1.0 / 20 animations:^{
                    
                    frame.origin.y += 5;
                    _line.frame = frame;
                    
                } completion:nil];
            }
        }
        else
        {
            flag = !flag;
        }
    }
    
    //NSLog(@"_line.frame.origin.y==%f",_line.frame.origin.y);
}

- (void)setOverlayPickerView:(UIView*)view
{
    //画中间的基准线
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth - 300) / 2.0, kLineMinY, 300, 12 * 300 / 320.0)];
    [_line setImage:[UIImage imageNamed:@"ff_QRCodeScanLine"]];

    [view addSubview:_line];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kLineMinY)];//80
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor blackColor];
    [view addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMinY, (kDeviceWidth - kReaderViewWidth) / 2.0, kReaderViewHeight)];
    leftView.alpha = 0.3;
    leftView.backgroundColor = [UIColor blackColor];
    [view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth - CGRectGetMaxX(leftView.frame), kLineMinY, CGRectGetMaxX(leftView.frame), kReaderViewHeight)];
    rightView.alpha = 0.3;
    rightView.backgroundColor = [UIColor blackColor];
    [view addSubview:rightView];
    
    CGFloat space_h = KDeviceHeight - kLineMaxY;
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMaxY, kDeviceWidth, space_h)];
    downView.alpha = 0.3;
    downView.backgroundColor = [UIColor blackColor];
    [view addSubview:downView];
    
    //四个边角
    UIImage *cornerImage = [UIImage imageNamed:@"ScanQR1"];
    
    //左侧的view
    UIImageView *leftView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame)+7 - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0+7, cornerImage.size.width, cornerImage.size.height)];
    leftView_image.image = cornerImage;
    [view addSubview:leftView_image];
    
    cornerImage = [UIImage imageNamed:@"ScanQR2"];
    
    //右侧的view
    UIImageView *rightView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0-7, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0+7, cornerImage.size.width, cornerImage.size.height)];
    rightView_image.image = cornerImage;
    [view addSubview:rightView_image];
    
    cornerImage = [UIImage imageNamed:@"ScanQR3"];
    
    //底部view
    UIImageView *downView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0+7, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0-7, cornerImage.size.width, cornerImage.size.height)];
    downView_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [view addSubview:downView_image];
    
    cornerImage = [UIImage imageNamed:@"ScanQR4"];
    
    UIImageView *downViewRight_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0-7, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0-7, cornerImage.size.width, cornerImage.size.height)];
    downViewRight_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [view addSubview:downViewRight_image];
    
    //说明label
    UILabel *labIntroudction = [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame = CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(downView.frame) + 25, kReaderViewWidth, 20);
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.font = [UIFont boldSystemFontOfSize:13.0];
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"将二维码放入框内,即可自动扫描";
    [view addSubview:labIntroudction];
    
    UIView *scanCropView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - 1,kLineMinY,view.frame.size.width - 2 * CGRectGetMaxX(leftView.frame) + 2, kReaderViewHeight + 2)];
    scanCropView.layer.borderColor = [UIColor clearColor].CGColor;
    scanCropView.layer.borderWidth = 2.0;
    [view addSubview:scanCropView];
}




- (CGRect)getReaderViewBoundsWithSize:(CGSize)asize
{
    return CGRectMake(kLineMinY / KDeviceHeight, ((kDeviceWidth - asize.width) / 2.0) / kDeviceWidth, asize.height / KDeviceHeight, asize.width / kDeviceWidth);
}

- (void)stopReader {

    
    if (_lineTimer)
    {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
    
    [self.captureSession stopRunning];
}

@end
