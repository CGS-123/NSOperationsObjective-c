//
//  ASOResizeImageOperation.m
//  AsynchronousOperations
//
//  Created by Colin Smith on 10/20/15.
//  Copyright © 2015 Colin Smith. All rights reserved.
//

#import "ASOResizeImageOperation.h"

@interface ASOResizeImageOperation ()

@property (strong, nonatomic) NSString *path;
@property (nonatomic) CGSize containingSize;

@end

@implementation ASOResizeImageOperation

- (instancetype)initWithPath:(NSString *)path andContainingSize:(CGSize)containingSize {
    self = [super init];
    if (self) {
        _path = path;
        _containingSize = containingSize;
    }
    return self;
}

- (void)execute {
    UIImage *sourceImage = [UIImage imageWithContentsOfFile:self.path];
    NSLog(@"Source image size: %@", NSStringFromCGSize(sourceImage.size));
    [self printSizeOnDiskWithData:UIImageJPEGRepresentation(sourceImage, 1.0)];

    CGFloat width;
    CGFloat height;
    CGFloat ratio = sourceImage.size.width / sourceImage.size.height;

    //aspect fit
    if (sourceImage.size.width >= sourceImage.size.height) {
        width = self.containingSize.width;
        height = width/ratio;
    } else {
        height = self.containingSize.height;
        width = height * ratio;
    }

    CGSize imageSize = CGSizeMake(width, height);
    NSLog(@"Resized Image: %@", NSStringFromCGSize(imageSize));

    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0.0);
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    [sourceImage drawInRect:rect];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8);
    [self printSizeOnDiskWithData:imageData];
    [imageData writeToFile:self.path atomically:YES];

    [self finish];
}

- (void)printSizeOnDiskWithData:(NSData *)data {
    NSUInteger dataLength = data.length;
    NSString *size = [NSByteCountFormatter stringFromByteCount:dataLength countStyle:NSByteCountFormatterCountStyleFile];
    NSLog(@"Size on disk: %@", size);
}

@end
