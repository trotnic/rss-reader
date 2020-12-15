//
//  RSSSourceViewModel.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import <Foundation/Foundation.h>
#import "RSSLinkViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RSSSourceViewModel <NSObject>

- (NSString *)sourceTitle;
- (NSArray<id<RSSLinkViewModel>> *)sourceRSSLinks;

@end

NS_ASSUME_NONNULL_END
