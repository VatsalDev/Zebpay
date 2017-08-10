//
//  SharedClass.h
//  ZebpayTest
//
//  Created by vatsal raval on 10/08/2017.
//  Copyright © 2017 vatsal raval. All rights reserved.
//

#import <Foundation/Foundation.h>

//CTSessionSharedManager

@interface SharedClass : NSObject

#define BASEURL @"https://rss.itunes.apple.com/api/v1/us/apple-music/"
#define NEWMUSICLIST @"new-music/10/explicit/json"
#define APPDELEGATE ((AppDelegate* ) [[UIApplication sharedApplication] delegate])

+ (instancetype _Nonnull) sharedInstance;

- (BOOL)connected;
- (void) getNewMusicArray: (void (^ _Nonnull)(id _Nullable, NSError * _Nullable)) responseBlock;
@end
