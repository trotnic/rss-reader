//
//  UVFeedChannel.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "UVFeedChannelViewModel.h"
#import "UVFeedChannelKeys.h"
#import "UVFeedItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVFeedChannel : NSObject <UVFeedChannelViewModel>

@property (nonatomic, copy, readonly) NSString *link;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, retain, readonly) NSArray<UVFeedItem *> *items;

+ (instancetype _Nullable)objectWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
