//
//  FeedXMLParser.h
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ParseHandler)(NSArray<FeedItem *> *, NSError *);

@interface FeedXMLParser : NSObject <NSXMLParserDelegate>

- (void)parseFeed:(NSData *)data completion:(ParseHandler)completion;

@end

NS_ASSUME_NONNULL_END
