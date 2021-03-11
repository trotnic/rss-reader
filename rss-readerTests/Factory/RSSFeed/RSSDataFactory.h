//
//  RSSFeedRawDataFactory.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <Foundation/Foundation.h>
#import "UVRSSFeed.h"
#import "UVRSSLink.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSSDataFactory : NSObject

+ (NSData *)rawGarbageData;
+ (NSData *)rawXMLData;
+ (NSData *)rawHTMLData;
+ (NSData *)rawHTMLDataNoRSS;
+ (NSData *)rawDataNil;
+ (UVRSSFeed *)channel;
+ (NSDictionary *)rawChannel;
+ (NSArray<UVRSSLink *> *)links;
+ (NSArray<UVRSSLink *> *)linksEmptyList;
+ (UVRSSLink *)linkSelected:(BOOL)selected;
+ (NSDictionary *)rawLinkFromXML;
+ (NSArray<NSDictionary *> *)rawLinksFromHTML;

@end

NS_ASSUME_NONNULL_END
