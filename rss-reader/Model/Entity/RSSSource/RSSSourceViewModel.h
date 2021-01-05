//
//  RSSSourceViewModel.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import <Foundation/Foundation.h>
#import "UVRSSLinkViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RSSSourceViewModel <NSObject>

- (NSString *)sourceAddress;
- (NSArray<id<UVRSSLinkViewModel>> *)sourceRSSLinks;

@end

NS_ASSUME_NONNULL_END
