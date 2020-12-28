//
//  UVRSSLinkXMLParser.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 28.12.20.
//

#import <Foundation/Foundation.h>
#import "UVRSSLinkXMLParserType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVRSSLinkXMLParser : NSObject <UVRSSLinkXMLParserType>

+ (instancetype)parser;

@end

NS_ASSUME_NONNULL_END
