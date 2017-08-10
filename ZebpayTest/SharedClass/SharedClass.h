//
//  SharedClass.h
//  Haptik
//
//  Created by vatsal raval on 04/12/2016.
//  Copyright © 2016 vatsal raval. All rights reserved.
//

#import <Foundation/Foundation.h>

//CTSessionSharedManager

@interface SharedClass : NSObject

#define BASEURL @"http://haptik.co/"
#define CHATLIST @"android/test_data/"

+ (instancetype _Nonnull) sharedInstance;

- (void) getGroupChatArray: (void (^ _Nonnull)(id _Nullable, NSError * _Nullable)) responseBlock;
@end
