//
//  SharedClass.m
//  ZebpayTest
//
//  Created by vatsal raval on 10/08/2017.
//  Copyright © 2017 vatsal raval. All rights reserved.
//

#import "SharedClass.h"
//#import "MsgDataModel.h"
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"

@interface SharedClass()

@property (nonatomic, strong) NSString* baseURL;

@end

@implementation SharedClass

#pragma mark - Shared Instance
+ (instancetype) sharedInstance
{
    static SharedClass* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SharedClass alloc] init];
        manager.baseURL = BASEURL;
    });
    return manager;
}

#pragma mark - General Functions
- (void) getNewMusicArray: (void (^)(id _Nullable, NSError * _Nullable)) responseBlock {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:self.baseURL]];
    [manager GET:NEWMUSICLIST parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray* responseArray = [NSMutableArray arrayWithCapacity:0];

        NSArray* resultArray = responseObject[@"feed"][@"results"];
        responseArray = [NSMutableArray arrayWithArray:resultArray];
        
        responseBlock(responseArray, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error - %@", error);
        responseBlock(nil, error);
    }];
}

-(BOOL)connected{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
