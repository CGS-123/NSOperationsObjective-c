//
//  ASOBaseOperation.h
//  AsynchronousOperations
//
//  Created by Colin Smith on 10/19/15.
//  Copyright © 2015 Colin Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASOBaseOperation : NSOperation

- (void)finish;
- (void)execute;

@end
