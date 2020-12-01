//
//  FeedItemViewModel.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FeedItemViewModel <NSObject>

@property (nonatomic, assign, getter=isExpand) BOOL expand;

- (NSString *)articleTitle;
- (NSString *)articleCategory;
- (NSString *)articleDate;
- (NSString *)articleDescription;

@end

NS_ASSUME_NONNULL_END
