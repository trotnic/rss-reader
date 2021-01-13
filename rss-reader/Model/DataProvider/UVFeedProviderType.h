//
//  UVFeedProviderType.h
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import <Foundation/Foundation.h>
#import "UVFeedParserType.h"
#import "UVFeedChannel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVFeedProviderType <NSObject>

- (void)discoverChannel:(NSData *)data
                 parser:(id<UVFeedParserType>)parser
             completion:(void(^)(UVFeedChannel *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
