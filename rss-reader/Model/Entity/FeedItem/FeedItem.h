//
//  FeedItem.h
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import <Foundation/Foundation.h>
#import "FeedItemViewModel.h"
#import "MediaContent.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const kRSSItem;
FOUNDATION_EXPORT NSString *const kRSSItemTitle;
FOUNDATION_EXPORT NSString *const kRSSItemLink;
FOUNDATION_EXPORT NSString *const kRSSItemSummary;
FOUNDATION_EXPORT NSString *const kRSSItemCategory;
FOUNDATION_EXPORT NSString *const kRSSItemPubDate;

@interface FeedItem : NSObject <FeedItemViewModel>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *link;
@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, copy, readonly) NSString *category;
@property (nonatomic, retain, readonly) NSArray<MediaContent *> *mediaContent;

NS_ASSUME_NONNULL_END

+ (nullable instancetype)objectWithDictionary:(NSDictionary *_Nonnull)dictionary;

@end
