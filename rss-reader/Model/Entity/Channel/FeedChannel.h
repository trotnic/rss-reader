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

extern NSString *const kRSSChannel;
extern NSString *const kRSSChannelLink;
extern NSString *const kRSSChannelTitle;
extern NSString *const kRSSChannelDescription;
extern NSString *const kRSSChannelItems;

@interface FeedChannel : NSObject <FeedChannelViewModel>

@property (nonatomic, copy, readonly) NSString *link;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, retain, readonly) NSArray<FeedItem *> *items;

NS_ASSUME_NONNULL_END

+ (nullable instancetype)objectWithDictionary:(NSDictionary *_Nonnull)dictionary;

@end

