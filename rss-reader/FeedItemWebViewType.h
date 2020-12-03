//
//  FeedItemViewType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12/3/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FeedItemWebViewType <NSObject>

- (void)openURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
