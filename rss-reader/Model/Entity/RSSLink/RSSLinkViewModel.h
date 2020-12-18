//
//  RSSLinkViewModel.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RSSLinkViewModel <NSObject>

- (NSString *)linkTitle;
- (BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
