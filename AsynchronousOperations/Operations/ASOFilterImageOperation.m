//
//  ASOFilterImageOperation.m
//  AsynchronousOperations
//
//  Created by Colin Smith on 10/21/15.
//  Copyright © 2015 Colin Smith. All rights reserved.
//

#import "ASOFilterImageOperation.h"

@interface ASOFilterImageOperation ()

@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) CIImage *inputImage;
@property (strong, nonatomic) CIFilter *filter;

@end

@implementation ASOFilterImageOperation

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        _path = path;
    }
    return self;
}

- (void)execute {
    self.outputImage = self.filter.outputImage;
    [self finish];
}

- (CIImage *)inputImage {
    if (!_inputImage) {
        NSURL *fileURL = [NSURL fileURLWithPath:self.path];
        _inputImage = [CIImage imageWithContentsOfURL:fileURL];
    }
    return _inputImage;
}

- (CIFilter *)filter {
    if (!_filter) {
        _filter = [CIFilter filterWithName:@"CISepiaTone" withInputParameters:@{kCIInputImageKey : self.inputImage}];
    }
    return _filter;
}

@end
