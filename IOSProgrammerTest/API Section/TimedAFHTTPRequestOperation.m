//
//  TimedAFHTTPRequestOperation.m
//  IOSProgrammerTest
//
//  Created by Kelvin Lee on 4/18/15.
//  Copyright (c) 2015 AppPartner. All rights reserved.
//

#import "TimedAFHTTPRequestOperation.h"

@implementation TimedAFHTTPRequestOperation

- (void)start
{
    self.startTime = CFAbsoluteTimeGetCurrent();
    
    [super start];
}

@end
