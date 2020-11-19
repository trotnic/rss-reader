//
//  FeedChannel.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const kRSSChannelTitle;
FOUNDATION_EXPORT NSString *const kRSSChannelLink;
FOUNDATION_EXPORT NSString *const kRSSChannelDescription;

@interface FeedChannel : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *link;
@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, retain, readonly) NSArray<FeedItem *> *items;

@end

NS_ASSUME_NONNULL_END
