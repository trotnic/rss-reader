//
//  UVFeedItemDisplayModel.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVFeedItemDisplayModel <NSObject>

@property (nonatomic, assign, getter=isExpand) BOOL expand;

- (NSString *)articleTitle;
- (NSString *)articleCategory;
- (NSString *)articleDate;
- (NSString *)articleDescription;

@end

NS_ASSUME_NONNULL_END
