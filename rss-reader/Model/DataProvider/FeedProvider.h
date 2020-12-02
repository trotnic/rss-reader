//
//  FeedProvider.h
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import <Foundation/Foundation.h>
#import "FeedProviderType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FeedParserType;

@interface FeedProvider : NSObject <FeedProviderType>

- (instancetype)initWithParser:(id<FeedParserType>)parser;

@end

NS_ASSUME_NONNULL_END
