//
//  UVFeedParser.h
//  rss-reader
//
//  Created by Uladzislau on 11/19/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVFeedParserType <NSObject>

- (void)parseData:(NSData *)data completion:(void(^)(NSDictionary *_Nullable, NSError *_Nullable))completion;

@end

NS_ASSUME_NONNULL_END
