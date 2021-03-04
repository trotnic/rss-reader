//
//  UVRSSLinkXMLParserType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 28.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVRSSLinkXMLParserType <NSObject>

- (void)parseData:(NSData *)data completion:(void(^)(NSDictionary * _Nullable, NSError * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
