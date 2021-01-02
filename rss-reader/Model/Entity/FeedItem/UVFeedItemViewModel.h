//
//  UVFeedItemViewModel.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVFeedItemViewModel <NSObject>

@property (nonatomic, assign, getter=isExpand) BOOL expand;
@property (nonatomic, assign) CGRect frame;

- (NSString *)articleTitle;
- (NSString *)articleCategory;
- (NSString *)articleDate;
- (NSString *)articleDescription;

@end

NS_ASSUME_NONNULL_END
