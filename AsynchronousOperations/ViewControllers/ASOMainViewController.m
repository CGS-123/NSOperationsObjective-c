//
//  ASOMainViewController.m
//  AsynchronousOperations
//
//  Created by Colin Smith on 10/19/15.
//  Copyright © 2015 Colin Smith. All rights reserved.
//

#import "ASOMainViewController.h"
#import "ASODownloadImageOperation.h"
#import "ASOResizeImageOperation.h"
#import "ASOFilterImageOperation.h"

@interface ASOMainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *downloadImageButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) NSOperationQueue *operationQueue;

@end

@implementation ASOMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.progress = 0;
}

- (IBAction)downloadImageButtonWasTouched:(id)sender {
    __weak typeof(self) weakSelf = self;
    self.operationQueue = [[NSOperationQueue alloc] init];
    NSURL *imageUrl = [NSURL URLWithString:@"http://imgsrc.hubblesite.org/hu/db/images/hs-2006-10-a-hires_jpg.jpg"];
    NSMutableArray *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) mutableCopy];
    NSString *targetPath = [documentsDirectory[0] stringByAppendingPathComponent:@"hubble.jpg"];

    CGSize size = CGSizeMake(self.imageView.bounds.size.width * 2, self.imageView.bounds.size.height * 2);
    ASODownloadImageOperation *downloadOperation = [[ASODownloadImageOperation alloc] initWithImageURL:imageUrl andTargetPath:targetPath];
    ASOResizeImageOperation *resizeOperation = [[ASOResizeImageOperation alloc] initWithPath:targetPath andContainingSize:size];
    ASOFilterImageOperation *filterOperation = [[ASOFilterImageOperation alloc] initWithPath:targetPath];
    __block ASOFilterImageOperation *weakFilterOperation = filterOperation;
    [resizeOperation addDependency:downloadOperation];
    [filterOperation addDependency:resizeOperation];

    downloadOperation.progressBlock = ^(float progress) {
        weakSelf.progressView.progress = progress;
    };

    filterOperation.completionBlock = ^{
        if (weakFilterOperation.outputImage) {
            CIImage *outputImage = weakFilterOperation.outputImage;
            CIContext *context = [CIContext contextWithOptions:nil];
            CGImageRef imageRef = [context createCGImage:outputImage fromRect:outputImage.extent];
            UIImage *imageToDisplay = [UIImage imageWithCGImage:imageRef];
            [self displayImage:imageToDisplay];
            weakSelf.progressView.hidden = YES;
        }
    };

    self.operationQueue.suspended = YES;
    [self.operationQueue addOperation:downloadOperation];
    [self.operationQueue addOperation:resizeOperation];
    [self.operationQueue addOperation:filterOperation];
    self.operationQueue.suspended = NO;
}

- (void)displayImage:(UIImage *)image {
    self.imageView.alpha = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = image;
        [UIView animateWithDuration:0.3 animations:^{
            self.imageView.alpha = 1;
        }];
    });
}

@end
