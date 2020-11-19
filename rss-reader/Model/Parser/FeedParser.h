//
//  FeedParser.h
//  rss-reader
//
//  Created by Uladzislau on 11/19/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FeedItem;
typedef void(^ParseHandler)(NSArray<FeedItem *> *, NSError *);

@protocol FeedParser <NSObject>

- (void)parseFeed:(NSData *)data completion:(ParseHandler)completion;

@end

NS_ASSUME_NONNULL_END
