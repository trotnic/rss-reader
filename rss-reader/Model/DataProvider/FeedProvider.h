//
//  FeedProvider.h
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import <Foundation/Foundation.h>
#import "NetworkServiceType.h"
#import "FeedProviderType.h"
#import "FeedParserType.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedProvider : NSObject <FeedProviderType>

- (instancetype)initWithNetwork:(id<NetworkServiceType>)service parser:(id<FeedParserType>)parser;

@end

NS_ASSUME_NONNULL_END
