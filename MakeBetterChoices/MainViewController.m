//
//  MainViewController.m
//  MakeBetterChoices
//
//  Created by Jamar Gibbs on 6/5/16.
//  Copyright © 2016 B3773R. All rights reserved.
//

#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScannedProduct.h"
#import "ProductDetailViewController.h"

@interface MainViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property AVCaptureSession *captureSession;
@property AVCaptureVideoPreviewLayer *captureLayer;
@property NSDictionary *productDataFields;
@property NSArray *productDataRecords;
@property ScannedProduct *scannedProduct;
@property NSString *scannedBarcode;
@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (weak, nonatomic) IBOutlet UITextField *barcodeOutlet;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpScanningSession];
    self.scannedProduct = [ScannedProduct new];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

-(void)setUpScanningSession {
    
    self.captureSession = [[AVCaptureSession alloc]init];

    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
     NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"Error Obtaining Camera input");
        return;
    }
    
    [self.captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput =
    [[AVCaptureMetadataOutput alloc]init];
    
    [self.captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("scanQue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    [captureMetadataOutput setMetadataObjectTypes:[captureMetadataOutput availableMetadataObjectTypes]];
    
    self.captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.captureLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.captureLayer setFrame:self.cameraPreviewView.layer.bounds];
    [self.cameraPreviewView.layer addSublayer:self.captureLayer];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {    
    NSArray *supportedBarcodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code,
                                       AVMetadataObjectTypeCode39Mod43Code,
                                       AVMetadataObjectTypeEAN13Code,
                                       AVMetadataObjectTypeEAN8Code,
                                       AVMetadataObjectTypeCode93Code,
                                       AVMetadataObjectTypeCode128Code,
                                       AVMetadataObjectTypePDF417Code,
                                       AVMetadataObjectTypeQRCode,
                                       AVMetadataObjectTypeAztecCode];
    for (AVMetadataObject *barcodeMetadata in metadataObjects) {
        for (NSString *supportedBarcode in supportedBarcodeTypes) {
            if ([supportedBarcode isEqualToString:barcodeMetadata.type]) {
                AVMetadataMachineReadableCodeObject *barcodeObject = (AVMetadataMachineReadableCodeObject *)[self.captureLayer transformedMetadataObjectForMetadataObject:barcodeMetadata];
                
                self.scannedBarcode = [barcodeObject stringValue];
                
                dispatch_sync(dispatch_get_main_queue(),^{
                    [self.captureSession stopRunning];
                    self.barcodeOutlet.text = self.scannedBarcode;
                    [self getFoodData];
                    NSLog(@"%@",self.scannedBarcode);
                });
                return;
            }
        }
    }
}

-(void)getFoodData {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://pod.opendatasoft.com/api/records/1.0/search/?dataset=pod_gtin&q=%@&facet=gpc_s_nm&facet=brand_nm&facet=owner_nm&facet=gln_nm&facet=prefix_nm",self.scannedBarcode]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *connectionError)

     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *returnedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             
             self.productDataRecords = [returnedData valueForKeyPath:@"records.fields"];
             
             self.productDataFields = [self.productDataRecords objectAtIndex:0];
             
             NSLog(@"%@",self.productDataFields[@"pkg_unit"]);
             NSLog(@"%@",self.productDataFields);
             
             self.scannedProduct.name = self.productDataFields[@"gtin_nm"];
             self.scannedProduct.image = self.productDataFields[@"gtin_img"];
             self.scannedProduct.brand = self.productDataFields[@"gln_nm"];
             self.scannedProduct.barcode = self.scannedBarcode;
             
             self.navigationItem.title = self.scannedProduct.name;
         }
     }];
    [task resume];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ProductDetailViewController *pdcVC = [segue destinationViewController];
    pdcVC.productDetails = self.scannedProduct;
    pdcVC.title = self.scannedProduct.name;
}

@end
