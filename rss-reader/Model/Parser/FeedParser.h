//
//  FeedParser.h
//  rss-reader
//
//  Created by Uladzislau on 11/19/20.
//

#import <Foundation/Foundation.h>

@class FeedChannel;
typedef void(^ParseHandler)(FeedChannel *, NSError *);

@protocol FeedParser <NSObject>

- (void)parseFeed:(NSData *)data completion:(ParseHandler)completion;

@end
