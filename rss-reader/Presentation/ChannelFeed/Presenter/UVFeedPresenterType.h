//
//  UVFeedPresenterType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVFeedPresenterType <NSObject>

- (void)updateFeed;
- (void)openArticleAt:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
