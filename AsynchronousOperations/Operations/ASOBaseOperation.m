//
//  ASOBaseOperation.m
//  AsynchronousOperations
//
//  Created by Colin Smith on 10/19/15.
//  Copyright © 2015 Colin Smith. All rights reserved.
//

#import "ASOBaseOperation.h"

static NSString *kIsExecuting = @"isExecuting";
static NSString *kIsFinished = @"isFinished";

@interface ASOBaseOperation ()

@property (nonatomic) BOOL currentlyFinished;
@property (nonatomic) BOOL currentlyExecuting;

@end

@implementation ASOBaseOperation

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentlyExecuting = NO;
        _currentlyFinished = NO;
    }
    return self;
}

- (BOOL)isAsynchronous {
    return YES;
}

- (void)start {
    [self willChangeValueForKey:kIsExecuting];
    _currentlyExecuting = YES;
    [self didChangeValueForKey:kIsExecuting];

    [self execute];
}

- (void)finish {
    [self willChangeValueForKey:kIsExecuting];
    _currentlyExecuting = NO;
    [self didChangeValueForKey:kIsExecuting];

    [self willChangeValueForKey:kIsFinished];
    _currentlyFinished = YES;
    [self didChangeValueForKey:kIsFinished];
}

- (void)execute {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (BOOL)isExecuting {
    return self.currentlyExecuting;
}

- (BOOL)isFinished {
    return self.currentlyFinished;
}

@end
