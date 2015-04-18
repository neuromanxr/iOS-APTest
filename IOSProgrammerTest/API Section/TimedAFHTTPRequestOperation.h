//
//  TimedAFHTTPRequestOperation.h
//  IOSProgrammerTest
//
//  Created by Kelvin Lee on 4/18/15.
//  Copyright (c) 2015 AppPartner. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

@interface TimedAFHTTPRequestOperation : AFHTTPRequestOperation

@property (nonatomic) CFAbsoluteTime startTime;

- (void)start;

@end
