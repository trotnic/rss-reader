//
//  FeedChannel.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "FeedChannelViewModel.h"
#import "FeedItem.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const kRSSChannel;
FOUNDATION_EXPORT NSString *const kRSSChannelTitle;
FOUNDATION_EXPORT NSString *const kRSSChannelLink;
FOUNDATION_EXPORT NSString *const kRSSChannelDescription;
FOUNDATION_EXPORT NSString *const kRSSChannelItems;

@interface FeedChannel : NSObject <FeedChannelViewModel>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *link;
@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, retain, readonly) NSArray<FeedItem *> *items;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
