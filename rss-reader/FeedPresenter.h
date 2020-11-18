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

NS_ASSUME_NONNULL_BEGIN

@interface FeedPresenter : NSObject <FeedPresenterType>

- (instancetype)initWithParser:(FeedXMLParser *)parser;
- (void)assignView:(id<FeedViewType>)view;

@end

NS_ASSUME_NONNULL_END
