//
//  ASODownloadImageOperation.h
//  AsynchronousOperations
//
//  Created by Colin Smith on 10/19/15.
//  Copyright © 2015 Colin Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASOBaseOperation.h"

@interface ASODownloadImageOperation : ASOBaseOperation

@property (strong, nonatomic) void(^progressBlock)(float progress);

- (instancetype)initWithImageURL:(NSURL *)imageURL andTargetPath:(NSString *)targetPath;

@end
