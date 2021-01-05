//
//  UVDataRecognizerType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <Foundation/Foundation.h>
#import "UVFeedParserType.h"

NS_ASSUME_NONNULL_BEGIN


@protocol UVDataRecognizerType <NSObject>

- (void)discoverLinks:(NSData *)data
           completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion;

- (void)discoverChannel:(NSData *)data
                 parser:(id<UVFeedParserType>)parser
             completion:(void(^)(NSDictionary *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
