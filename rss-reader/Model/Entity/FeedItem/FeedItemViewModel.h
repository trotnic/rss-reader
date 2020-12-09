//
//  FeedItemViewModel.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FeedItemViewModel <NSObject>

- (NSString *)articleTitle;
- (NSString *)articleCategory;
- (NSString *)articleDate;

@end

NS_ASSUME_NONNULL_END
