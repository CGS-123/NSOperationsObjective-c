//
//  ASOMainViewController.m
//  AsynchronousOperations
//
//  Created by Colin Smith on 10/19/15.
//  Copyright © 2015 Colin Smith. All rights reserved.
//

#import "ASOMainViewController.h"
#import "ASODownloadImageOperation.h"

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
    NSURL *imageUrl = [NSURL URLWithString:@"http://imgsrc.hubblesite.org/hu/db/images/hs-2006-10-a-hires_jpg.jpg"];
    NSMutableArray *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) mutableCopy];
    NSString *targetPath = [documentsDirectory[0] stringByAppendingPathComponent:@"hubble.jpg"];

    ASODownloadImageOperation *downloadOperation = [[ASODownloadImageOperation alloc] initWithImageURL:imageUrl andTargetPath:targetPath];

    downloadOperation.progressBlock = ^(float progress) {
        weakSelf.progressView.progress = progress;
    };

    downloadOperation.completionBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:targetPath];
            [weakSelf displayImage:image];
            weakSelf.progressView.hidden = YES;
        });
    };
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self.operationQueue addOperation:downloadOperation];
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
