//
//  ASOResizeImageOperation.h
//  AsynchronousOperations
//
//  Created by Colin Smith on 10/20/15.
//  Copyright © 2015 Colin Smith. All rights reserved.
//

#import "ASOBaseOperation.h"
#import <UIKit/UIKit.h>

@interface ASOResizeImageOperation : ASOBaseOperation

- (instancetype)initWithPath:(NSString *)path andContainingSize:(CGSize)containingSize;

@end
