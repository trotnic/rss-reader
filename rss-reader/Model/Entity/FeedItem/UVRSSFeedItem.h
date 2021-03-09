//
//  UVRSSFeedItem.h
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import <Foundation/Foundation.h>
#import "UVFeedItemDisplayModel.h"
#import "UVFeedItemKeys.h"
#import "UVRSSItemState.h"
#import "UVPropertyListConvertible.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVRSSFeedItem : NSObject <UVFeedItemDisplayModel, UVPropertyListConvertible>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) NSDate *pubDate;
@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, copy, readonly) NSString *category;
@property (nonatomic, assign, getter=isExpand) BOOL expand;
@property (nonatomic, assign) UVRSSItemState readingState;

NS_ASSUME_NONNULL_END

+ (nullable instancetype)objectWithDictionary:(NSDictionary *_Nonnull)dictionary;

@end
