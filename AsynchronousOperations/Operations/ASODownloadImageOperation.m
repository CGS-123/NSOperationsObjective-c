//
//  ASODownloadImageOperation.m
//  AsynchronousOperations
//
//  Created by Colin Smith on 10/19/15.
//  Copyright © 2015 Colin Smith. All rights reserved.
//

#import "ASODownloadImageOperation.h"

@interface ASODownloadImageOperation () <NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *targetPath;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;

@end

@implementation ASODownloadImageOperation

- (instancetype)initWithImageURL:(NSURL *)imageURL andTargetPath:(NSString *)targetPath {
    self = [super init];
    if (self) {
        _imageURL = imageURL;
        _targetPath = targetPath;
    }
    return self;
}

- (void)execute {
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.targetPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.targetPath error:nil];
    }
    self.downloadTask = [self.session downloadTaskWithURL:self.imageURL];
    [self.downloadTask resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressBlock(progress);
    });

}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
        didFinishDownloadingToURL:(NSURL *)location {
    NSURL *targetURL = [NSURL fileURLWithPath:self.targetPath];
    NSError *error;
    if ([[NSFileManager defaultManager] copyItemAtURL:location toURL:targetURL error:&error]) {
        [self finish];
    } else {
        NSLog(@"wrong");
    }
}

- (NSURLSession *)session {
    if(!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    return _session;
}

@end
