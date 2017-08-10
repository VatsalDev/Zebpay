//
//  SharedClass.m
//  Haptik
//
//  Created by vatsal raval on 04/12/2016.
//  Copyright © 2016 vatsal raval. All rights reserved.
//

#import "SharedClass.h"
#import "MsgDataModel.h"
#import <AFNetworking/AFNetworking.h>

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
- (void) getGroupChatArray: (void (^)(id _Nullable, NSError * _Nullable)) responseBlock {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:self.baseURL]];
    [manager GET:CHATLIST parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray* messagesArray = [NSMutableArray arrayWithCapacity:0];

        NSArray* responseMessages = responseObject[@"messages"];
//        for(NSMutableDictionary* responseDict in responseMessages) {
//            MsgDataModel* newMsg = [[MsgDataModel alloc] initWithName:responseDict[@"Name"] withUserName:responseDict[@"username"] withImageURL:responseDict[@"image-url"] withMsgText:responseDict[@"body"] withMsgTime:responseDict[@"message-time"]];
//            [messagesArray addObject:newMsg];
//        }
        
        messagesArray = [NSMutableArray arrayWithArray:responseMessages];
        
        responseBlock(messagesArray, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error - %@", error);
        responseBlock(nil, error);
    }];
    
}
@end
