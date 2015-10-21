//
//  ASOFilterImageOperation.h
//  AsynchronousOperations
//
//  Created by Colin Smith on 10/21/15.
//  Copyright © 2015 Colin Smith. All rights reserved.
//

#import "ASOBaseOperation.h"
#import <CoreImage/CoreImage.h>

@interface ASOFilterImageOperation : ASOBaseOperation

@property (strong, nonatomic) CIImage *outputImage;

- (instancetype)initWithPath:(NSString *)path;

@end
