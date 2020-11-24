//
//  FeedPresenterType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FeedPresenterType <NSObject>

- (void)updateFeed;
- (void)selectRowAt:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
