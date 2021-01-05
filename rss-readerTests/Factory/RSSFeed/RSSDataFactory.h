//
//  RSSFeedRawDataFactory.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <Foundation/Foundation.h>
#import "UVFeedChannel.h"
#import "RSSSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSSDataFactory : NSObject

+ (NSData *)rawData;
+ (NSData *)rawDataNil;
+ (UVFeedChannel *)channel;
+ (NSDictionary *)rawChannel;
+ (NSArray<RSSLink *> *)links;
+ (RSSLink *)linkSelected:(BOOL)selected;
+ (RSSSource *)sourceWithLinksSelectedYES;
+ (RSSSource *)sourceNoLinksSelectedNO;

@end

NS_ASSUME_NONNULL_END
