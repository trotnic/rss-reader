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

+ (NSData *)rawGarbageData;
+ (NSData *)rawXMLData;
+ (NSData *)rawHTMLData;
+ (NSData *)rawHTMLDataNoRSS;
+ (NSData *)rawDataNil;
+ (UVFeedChannel *)channel;
+ (NSDictionary *)rawChannel;
+ (NSArray<RSSLink *> *)links;
+ (RSSLink *)linkSelected:(BOOL)selected;
+ (RSSSource *)sourceWithLinksSelectedYES;
+ (RSSSource *)sourceNoLinksSelected:(BOOL)selected;
+ (NSDictionary *)rawSourceFromHTML;
+ (NSDictionary *)rawLinkFromXML;
+ (NSArray<NSDictionary *> *)rawLinksFromHTML;

+ (NSDictionary *)rawSourceFromPlistSelectedYES;
+ (NSDictionary *)rawSourceFromPlistSelectedNO;
+ (RSSSource *)sourceFromPlistSelectedYES;
+ (RSSSource *)sourceFromPlistSelectedNO;

@end

NS_ASSUME_NONNULL_END
