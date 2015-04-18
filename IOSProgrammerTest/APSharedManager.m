//
//  APSharedManager.m
//  IOSProgrammerTest
//
//  Created by Kelvin Lee on 4/17/15.
//  Copyright (c) 2015 AppPartner. All rights reserved.
//

#import "APSharedManager.h"
#import "AFNetworking.h"

#define LOGIN_URL @"http://dev.apppartner.com/AppPartnerProgrammerTest/scripts/login.php"

@interface APSharedManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *operationManager;

@end

@implementation APSharedManager

+ (instancetype)sharedManager
{
    static APSharedManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[APSharedManager alloc] init];
        
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        self.operationManager = manager;
    }
    
    return self;
}

- (void)postLoginWithParameters:(NSDictionary *)parameters completionBlock:(APResponseBlock)response
{
    AFHTTPRequestOperationManager *manager = [[APSharedManager sharedManager] operationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:LOGIN_URL
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"SUCCESS JSON: %@", responseObject);
        
        if (response) {
            NSLog(@"RESPONSE BLOCK");
            response(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
        if (response)
            response(nil, error);
    }];
}

@end
