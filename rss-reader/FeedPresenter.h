//
//  FeedPresenter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "FeedPresenterType.h"
#import "FeedViewType.h"
#import "FeedParser.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RouterType;

@interface FeedPresenter : NSObject <FeedPresenterType>

- (instancetype)initWithParser:(id<FeedParser>)parser router:(id<RouterType>)router;
- (void)assignView:(id<FeedViewType>)view;

@end

NS_ASSUME_NONNULL_END
