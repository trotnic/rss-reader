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

@interface FeedItem : NSObject <FeedItemViewModel>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *link;
@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, copy, readonly) NSString *category;
@property (nonatomic, retain, readonly) NSArray<MediaContent *> *mediaContent;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
