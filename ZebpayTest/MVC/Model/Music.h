//
//  Music.h
//  ZebpayTest
//
//  Created by vatsal raval on 10/08/2017.
//  Copyright © 2017 vatsal raval. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Music : NSManagedObject

@property(nonatomic,retain) NSString *artistId;
@property(nonatomic,retain) NSString *artistName;
@property(nonatomic,retain) NSString *artistURL;
@property(nonatomic,retain) NSData *genereNames;
@property(nonatomic,retain) NSString *artworkUrl100;

@end
