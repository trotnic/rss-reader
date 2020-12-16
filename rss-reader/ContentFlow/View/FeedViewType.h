//
//  FeedViewType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "BaseViewType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FeedChannelViewModel;

@protocol FeedViewType <BaseViewType>

- (void)toggleActivityIndicator:(BOOL)show;
- (void)presentWebPageOnLink:(NSString *)link;

@end

NS_ASSUME_NONNULL_END
