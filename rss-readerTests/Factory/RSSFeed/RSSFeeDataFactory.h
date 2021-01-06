//
//  RSSFeedRawDataFactory.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <Foundation/Foundation.h>
#import "UVFeedChannel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSSFeeDataFactory : NSObject

+ (NSData *)rawData;
+ (UVFeedChannel *)channel;

@end

NS_ASSUME_NONNULL_END
