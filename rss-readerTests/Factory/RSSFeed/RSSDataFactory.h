//
//  RSSFeedRawDataFactory.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <Foundation/Foundation.h>
#import "UVFeedChannel.h"
#import "RSSLink.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSSDataFactory : NSObject

+ (NSData *)rawGarbageData;
+ (NSData *)rawXMLData;
+ (NSData *)rawHTMLData;
+ (NSData *)rawHTMLDataNoRSS;
+ (NSData *)rawDataNil;
+ (UVFeedChannel *)channel;
+ (NSDictionary *)rawChannel;
+ (NSArray<RSSLink *> *)links;
+ (NSArray<RSSLink *> *)linksEmptyList;
+ (RSSLink *)linkSelected:(BOOL)selected;
+ (NSDictionary *)rawLinkFromXML;
+ (NSArray<NSDictionary *> *)rawLinksFromHTML;

@end

NS_ASSUME_NONNULL_END
