//
//  UVRSSLinkXMLParserType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 28.12.20.
//

#import <Foundation/Foundation.h>
#import "RSSLink.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVRSSLinkXMLParserType <NSObject>

- (void)parseData:(NSData *)data completion:(void(^)(RSSLink *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
