//
//  UVFeedItem.h
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import <Foundation/Foundation.h>
#import "UVFeedItemDisplayModel.h"
#import "UVFeedItemKeys.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVFeedItem : NSObject <UVFeedItemDisplayModel>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, copy, readonly) NSString *category;

NS_ASSUME_NONNULL_END

+ (nullable instancetype)objectWithDictionary:(NSDictionary *_Nonnull)dictionary;

@end
