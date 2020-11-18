//
//  FeedPresenter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "FeedViewType.h"
#import "FeedXMLParser.h"
#import "FeedPresenterType.h"
#import "RouterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedPresenter : NSObject <FeedPresenterType>

- (instancetype)initWithParser:(FeedXMLParser *)parser router:(id<RouterType>)router;
- (void)assignView:(id<FeedViewType>)view;

@end

NS_ASSUME_NONNULL_END
