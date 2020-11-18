//
//  FeedItem.h
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import <Foundation/Foundation.h>
#import "FeedItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedItem : NSObject <FeedItemViewModel>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *link;
@property (nonatomic, copy, readonly) NSString *imageLink;
@property (nonatomic, retain, readonly) NSArray *mediaLinks;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
