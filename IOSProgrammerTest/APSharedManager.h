//
//  APSharedManager.h
//  IOSProgrammerTest
//
//  Created by Kelvin Lee on 4/17/15.
//  Copyright (c) 2015 AppPartner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^APResponseBlock) (id responseObject, NSError *error);

@interface APSharedManager : NSObject

+ (instancetype)sharedManager;

- (void)postLoginWithParameters:(NSDictionary *)parameters completionBlock:(APResponseBlock)response;

@end
