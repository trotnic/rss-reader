//
//  FeedPresenter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "FeedParser.h"
#import "FeedItem.h"
#import "FeedViewType.h"
#import "FeedPresenterType.h"
#import "RouterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedPresenter : NSObject <FeedPresenterType>

- (instancetype)initWithParser:(id<FeedParser>)parser router:(id<RouterType>)router;
- (void)assignView:(id<FeedViewType>)view;

@end

NS_ASSUME_NONNULL_END
