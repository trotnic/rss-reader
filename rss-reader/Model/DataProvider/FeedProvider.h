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
@protocol NetworkServiceType;

@interface FeedProvider : NSObject <FeedProviderType>

- (instancetype)initWithNetwork:(id<NetworkServiceType>)service parser:(id<FeedParserType>)parser;

@end

NS_ASSUME_NONNULL_END
