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

NS_ASSUME_NONNULL_BEGIN

@interface UVRSSFeedItem : NSObject <UVFeedItemDisplayModel>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, copy, readonly) NSString *category;
@property (nonatomic, assign, getter=isExpand) BOOL expand;
@property (nonatomic, assign) UVRSSItemOptionState readingState;

NS_ASSUME_NONNULL_END

+ (nullable instancetype)objectWithDictionary:(NSDictionary *_Nonnull)dictionary;

@end
